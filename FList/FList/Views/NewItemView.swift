import SwiftUI

class GlobalDate: ObservableObject
{
    static let shared = GlobalDate()

    @Published var notificationBody: Date = Date()
}

class GlobalAlert: ObservableObject
{
    static let shared = GlobalAlert()

    @Published var alert: Bool = false
}

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    @StateObject var notification = GlobalDate.shared
    
    //Remind state
    @State var remind : Bool = false
    let notify = NotificationHandler()
    //MyAlert
    @StateObject var alert = GlobalAlert.shared
    //Error choice Date
    @State var errorDate = false
    //For repeat notifications
    @State var repeatEnabled = false
    
    //For test tasks
    @State var showEXTasksBtn = false
    
    var body: some View {
        VStack {
            Text("New Task")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 60)
            
            Form {
                TextEditor(text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                Toggle("Remind me of that", isOn: $remind)
                    .bold()
                
                HStack {
                    Spacer()
                    Button("Save") {
                        if viewModel.canSave {
                            let now = Date()
                            if now < viewModel.dueDate {
                                viewModel.save()
                                newItemPresented = false
                                
    //                            notification.notificationBody = viewModel.dueDate
                            } else {
                                errorDate.toggle()
                            }
                        } else {
                            viewModel.showAlert.toggle()
                        }
                    }
                    .frame(width: 300).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
                    Spacer()
                }
                .padding(.top, 20)
                
                if showEXTasksBtn == true {
                    HStack {
                        Spacer()
                    Button("Add 3x Example Tasks") {
                        var num = 0
                        
                        while num < 3 {
                            viewModel.title = "This is Exxxmaple Task"
                            
                            viewModel.save()
                            newItemPresented = false
                            
                            num += 1
                            
                            print("Cycle \(num) passed")
                            
                            //                            notification.notificationBody = viewModel.dueDate
                        }
                    }
                    .frame(width: 300).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
                        Spacer()
                    }
                }
                
                if showEXTasksBtn == true {
                    HStack {
                        Spacer()
                    Button("Add 50x Example Tasks") {
                        var num = 0
                        
                        while num < 50 {
//                            viewModel.title = "This is Exxxmaple Task"
                            
                            viewModel.save()
                            
                            num += 1
                            
                            print("Cycle \(num) passed")
                            
                            //                            notification.notificationBody = viewModel.dueDate
                        }
                        newItemPresented = false
                    }
                    .frame(width: 300).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
                        Spacer()
                    }
                }
                
                if showEXTasksBtn == true {
                    HStack {
                        Spacer()
                    Button("Add 500x Example Tasks") {
                        var num = 0
                        
                        while num < 500 {
                            viewModel.title = "Random Task \(Int.random(in:1..<99999999))"
                            
                            viewModel.save()
                            newItemPresented = false
                            
                            num += 1
                            
                            print("Cycle \(num) passed")
                        }
                    }
                    .frame(width: 300).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
                        Spacer()
                    }
                }
                
            }
            .alert("Please Fill Task Text", isPresented: $viewModel.showAlert) {
                Button("Ok") {}
            }
            .alert("Please select the correct Date.", isPresented: $errorDate) {
                Button("Ok") {}
            }
        }
        .onAppear {
            //Variable for DefaultSN
            let sendDefaultN = UserDefaults.standard.bool(forKey: "defaultSN")
            
            //Set Alert Toggle
            if sendDefaultN == true {
                remind = true
                print("DefaultSN is True")
                print("DefaultSNToggle is True")
            }
            
            if sendDefaultN == false {
                remind = false
                print("DefaultSN is False")
                print("DefaultSNToggle is False")
            }
            
            //set showEXTasksBtn view?
            let showEXTasksBtnAppData = UserDefaults.standard.bool(forKey: "showEXTasksBtn")
            
            if showEXTasksBtnAppData == true {
                showEXTasksBtn = true
            }
            if showEXTasksBtnAppData == false {
                showEXTasksBtn = false
            }
            
            viewModel.dueDate = Date()
        }
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
}
