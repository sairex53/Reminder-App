import Foundation
import SwiftData

@Model
class Destination{
    var meaning : Bool
    
    init(meaning: Bool) {
        self.meaning = meaning
    }
}
