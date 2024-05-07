import SwiftUI
import LocalAuthentication

class GlobalFaceID: ObservableObject {
    static let shared = GlobalFaceID()
    
    @Published var tabItem: Bool = true
}

struct FaceID: View {
    @State private var logged = false
    
    @State var tabItem = GlobalFaceID.shared
    
    var body: some View {
        VStack {            
            if logged {
                ToDoListView(userId: "da4ZccErenST6xWk6AcyJROAPS93")
            } else {
                Spacer()
                Button{
                    authenticate()
                } label: {
                    Text("Unlock")
                        .font(.system(size: 20))
                        .bold()
                }
                .frame(width: 240).frame(height: 37).background(Color.blue).cornerRadius(10).tint(Color.white)
                .font(.system(size: 20))
                .padding(.bottom, 50)
            }
        }
    }
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        if scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    func authenticate() {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock") { (status, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            withAnimation(.easeOut) {logged = true}
        }
    }
}

#Preview {
    FaceID()
}
