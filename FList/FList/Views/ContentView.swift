import SwiftUI
import LocalAuthentication

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    //FaceID
    @State private var logged = false
    
    //For normal working PinCode
    @Environment(\.scenePhase) private var phase
    
    var body: some View {
        VStack {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                let lockScreen =  UserDefaults.standard.bool(forKey: "lockScreen")
                if !lockScreen {
                    if logged {
                        accountView
                    } else {
                        LockView(lockType: .both, lockPin: "2995", isEnabled: true) {
                            VStack {
                                accountView
                            }
                        }
                    }
                } else {
                    accountView
                }
            } else {
                LoginView()
            }
        }
        .onChange(of:phase) { oldValue, newValue in
            if newValue != .active {
                LockView(lockType: .both, lockPin: "2995", isEnabled: true) {
                    VStack {
                        accountView
                    }
                }
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
    @State var tabItem = GlobalFaceID.shared
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
