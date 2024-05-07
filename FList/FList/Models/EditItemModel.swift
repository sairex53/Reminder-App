import Foundation

struct Item {
    let id: String
    var title: String
    let dueDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
