import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    //For alert
    let defaults = UserDefaults.standard
    
    //For Notifications
    let notify = NotificationHandler()
    @StateObject var viewItem = NewItemViewViewModel()
    //For delete all Tasks
    @State var deleteAllTasks = false
    //For show Alert about restarting program
    @State var alertReopen = false
    @State var idDelete = String()
    
    //Face ID
    @StateObject var lockScreen = GlobalLock.shared
    //PinCode
    @State var viewPinCode = false
    
    //For edit task
    @State private var editItem = false
    @State var remind : Bool = false
    
    //For item Edit Task
    @State var itemId = String()
    @State var itemTitle = String()
    @State var itemDate = Date()
    
    @StateObject var editItemModel = NewItemViewViewModel()
    @StateObject var notification = GlobalDate.shared
    
    @State var updateList = false
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/todos")
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        ToDoList()
    }
    
    @ViewBuilder
    func ToDoList() -> some View {
        NavigationView {
            VStack {
                List(items) { item in
                    HStack {
                        ToDoListItemView(item: item)
                            .swipeActions(edge: .trailing) {
                                Button("Delete") {
                                    let alert = UserDefaults.standard.bool(forKey: "bool")
                                    if alert == true {
                                        idDelete = item.id
                                        viewModel.showAlert = true
                                    } else {
                                        viewModel.delete(id: item.id)
                                    }
                                }
                            }
                            .tint(.red)
                        
                            .swipeActions(edge: .leading) {
                                Button("Edit") {
                                    itemId = item.id
                                    itemTitle = item.title
                                    
                                    editItem.toggle()
                                }
                            }
                            .tint(.green)
                            .swipeActions(edge: .leading) {
                                Button("Copy") {
                                    UIPasteboard.general.string = item.title
                                }
                            }
                            .tint(.yellow)
                            .onAppear {
                                //Cancel Notify for Reload items Notifications
                                notify.cancelNotification()
                                print("#Notifications Canceled")
                                
                                let deleteOTData = UserDefaults.standard.bool(forKey: "deleteOutdated")
                                if deleteOTData == true {
                                    for item in items {
                                        let now = Date().timeIntervalSince1970
                                        
                                        if now >= item.dueDate {
                                            viewModel.delete(id: item.id)
                                        }
                                    }
                                }
                                
                                //Get notifications
                                let sendNotifications = UserDefaults.standard.bool(forKey: "cancelAN")
                                //Trust send notifications
                                if sendNotifications == true {
                                    print("✅ Notifications send allowed")
                                    // delayed action
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                                        for i in items {
                                            let now = Date().timeIntervalSince1970
                                            if i.dueDate >= now {
                                                notify.sendNotification(
                                                    date: Date(timeIntervalSince1970: i.dueDate),
                                                    type: "date",
                                                    title: "Reminder",
                                                    body: i.title)
                                                print("🔔Notificaiton planned: \(i.title)")
                                            } else {
                                                print("\(i.title) < \(now)")
//                                            }
                                        }
                                    }
                                }
                                
                                //Get trust for delete
                                let sureDeleteTasks = UserDefaults.standard.bool(forKey: "delete")
                                //Delete All Tasks
                                if sureDeleteTasks == true {
                                    for item in items {
                                        viewModel.delete(id: item.id)
                                    }
                                    //Return default
                                    var _: Void = UserDefaults.standard.set(false, forKey: "delete")
                                }
                                
                                //Delete Completed Tasks
                                let deleteCTData = UserDefaults.standard.bool(forKey: "deleteCT")
                                if deleteCTData {
                                    if item.isDone == true {
                                        viewModel.delete(id: item.id)
                                    }
                                }
                            }
                    }
                }
                .sheet(isPresented: $editItem) {
                    NavigationView {
                        VStack {
                            Text("Edit Task")
                                .font(.system(size: 32))
                                .bold()
                                .padding(.top, 60)
                            
                            Form {
                                HStack {
                                    TextField("Title", text: $editItemModel.title)
                                        .textFieldStyle(DefaultTextFieldStyle())
                                    
                                    Button("Clear") {
                                        editItemModel.title = ""
                                    }
                                }
                                
                                DatePicker("Due Date", selection: $editItemModel.dueDate)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                
                                Toggle("Remind me of that", isOn: $remind)
                                    .bold()
                                
                            }
                            .alert(isPresented: $viewModel.showAlert) {
                                Alert(title: Text("Error"),
                                      message: Text("Please fill in all fields and select due date that is today on newer.")
                                )
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Save") {
                                    viewModel.delete(id: itemId)
                                    
                                    if editItemModel.canSave {
                                        editItemModel.save()
                                        
                                        editItem.toggle()
                                        
//                                                notification.notificationBody = editItemModel.dueDate
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    editItem.toggle()
                                }
                            }
                        }
                        .onAppear {
                            //Completion Task for EditTask View
                            editItemModel.title = itemTitle
//                            editItemModel.dueDate.timeIntervalSince1970 = Date(itemDate)
                            
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
                        }
                    }
                }
                .alert("Are you sure?", isPresented: $viewModel.showAlert) {
                    Button(role: .destructive) {
                        viewModel.delete(id: idDelete)
                        //Cancel Notify for Reload items Notifications
                        notify.cancelNotification()
                        print("#Notifications Canceled")
                        
                        for i in items {
                            notify.sendNotification(
                                date: Date(timeIntervalSince1970: i.dueDate),
                                type: "date",
                                title: "Reminder",
                                body: i.title)
                            print("$Remind Loaded: \(i.title)")
                        }
                    } label: {Text("Delete").bold()}
                    Button(role: .cancel) {} label: {Text("No").bold()}
                }
                .tint(.red)
                .listStyle(PlainListStyle())
            }
            .navigationTitle("To Do List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        deleteAllTasks.toggle()
                    } label: {
                        Image(systemName: "folder.badge.minus")
                    }.alert("Do you really delete all Tasks?", isPresented: $deleteAllTasks) {
                        Button("No", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            //Cancel Notifications
                            notify.cancelNotification()
                            print("#Notifications Canceled")
                            
                            for item in items {
                                viewModel.delete(id: item.id)
                            }
                            print("All Items deleted")
                            
//                            viewModel.itemDelete.removeAll()
                            
//                            var _: Void = UserDefaults.standard.set(true, forKey: "delete")
                            
//                            alertReopen.toggle()
                        }
                    }
                    .alert("Please reopen app for apply changes", isPresented: $alertReopen) {
                        Button("Ok") {}
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingNewItemView = true
                    } label: {
                        Image(systemName: "plus")
                        
                    }
                }
            }
        }
        .onAppear {
            notify.askPermission()
        }
        .sheet(isPresented: $viewModel.showingNewItemView) {
            NewItemView(newItemPresented: $viewModel.showingNewItemView)
        }
    }
}

#Preview {
    ToDoListView(userId: "da4ZccErenST6xWk6AcyJROAPS93")
}
