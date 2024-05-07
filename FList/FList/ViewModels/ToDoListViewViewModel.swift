import Foundation
import FirebaseFirestore

class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    //Confirmation Alert
    @Published var showAlert = false
    @Published var alert : Bool = false
    @Published var itemDelete: String = ""
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    //Delete to do list item
    func delete(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
    }
}
