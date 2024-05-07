import SwiftUI
import SwiftData
import FirebaseFirestoreSwift

struct ToDoListItemView: View {
    @StateObject var viewModel = ToDoListItemViewViewModel()
    
    let item: ToDoListItem
    
    @Environment(\.modelContext) var modelContext
    @Query var destinations: [Destination]
    
    //For Reset Notifications by reload list items
    @State var notify = NotificationHandler()
    
    @State var hideText = false
    
    @State var copied = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                    .bold()
                
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.gray))
            }
            .onAppear {
                //Checking The posibility of cancel Notification
                let posibility = UserDefaults.standard.bool(forKey: "cancelAN")
                
                if posibility == true {
                    notify.sendNotification(
                        date: Date(timeIntervalSince1970: item.dueDate),
                        type: "date",
                        title: "Reminder",
                        body: item.title)
                    print("$Remind Loaded: \(item.title)")
                } else {
                    print("#Notification isn't loaded")
                    _ = UserDefaults.standard
                }
            }
            Spacer()
            
            ZStack {
                Button {
                    viewModel.toggleIsDone(item: item)
                    //                notify.cancelNotification()
                } label: {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    ToDoListItemView(item: .init(
        id: "123",
        title: "Get milk, Get fucking milk, Please get milk, what a fuck ?",
        dueDate: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: true))
}
