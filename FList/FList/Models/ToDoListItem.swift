import Foundation

struct ToDoListItem: Codable, Identifiable {
    let id: String
    var title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
