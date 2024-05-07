import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditItem: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var EditItemPresented: Bool
    
    @StateObject var notification = GlobalDate.shared
    
    //Remind state
    @State var remind : Bool = false
    let notify = NotificationHandler()
    //MyAlert
    @StateObject var alert = GlobalAlert.shared
    
    @State var showAlert = false
    //Error choice Date
    @State var errorDate = false
    
    //For completion Item Data
    var currentId =  UserDefaults.standard.string(forKey: "id")
    var currentTitle =  UserDefaults.standard.string(forKey: "title")
    var currentIsDone =  UserDefaults.standard.bool(forKey: "isDone")
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Text")
                    .font(.system(size: 32))
                    .bold()
                    .padding(.top, 60)
                
                Form {
                    TextField("Title", text: $viewModel.title)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    DatePicker("Due Date", selection: $viewModel.dueDate)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                    Toggle("Remind me of that", isOn: $remind)
                        .bold()
                    
                }
                .alert("Please Fill Task Text", isPresented: $viewModel.showAlert) {
                    Button("Ok") {}
                }
                .alert("Please select the correct Date.", isPresented: $errorDate) {
                    Button("Ok") {}
                }
            }
            .onAppear {
                viewModel.title = currentTitle ?? ""
                remind = currentIsDone
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //                        @StateObject var itemId = GlobalItem.shared
                        //                        
                        //                        forDeleteModel.delete(id: itemId)
                        //                        print("#Item - \(itemId) deleted from List")
                        
                        if viewModel.canSave {
                            viewModel.save()
                            EditItemPresented = false
                            
                            notification.notificationBody = viewModel.dueDate
                        }
                    } label: {Text("Save")}
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        EditItemPresented = false
                        
                    } label: {Text("Cancel")}
                }
            }
        }
    }
}

#Preview {
    EditItem(EditItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
}
