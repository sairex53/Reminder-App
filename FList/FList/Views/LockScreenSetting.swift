import SwiftUI

class GlobalLock: ObservableObject {
    static let shared = GlobalLock()
    
    @Published var isEnabled: Bool = false
}

struct LockScreenSetting: View {
    @StateObject var lockScreen = GlobalLock.shared
    
    var body: some View {
        VStack {
            Toggle("App Lock Screen", isOn: $lockScreen.isEnabled)
                .padding(.top, 40)
                .onChange(of: lockScreen.isEnabled) {
                    let defaults = UserDefaults.standard
                    
                    if lockScreen.isEnabled == false {
                        defaults.set(true, forKey: "lockScreen")
                        print("lockScreen Toggle Disabled")
                    }
                    
                    if lockScreen.isEnabled == true {
                        defaults.set(false, forKey: "lockScreen")
                        print("lockScreen Toggle is Enabled")
                    }
                }
                .frame(width: 200)
                
            Spacer()
        }
        .onAppear {
            var lockScreenEnabled = UserDefaults.standard.bool(forKey: "lockScreen")
            
            if lockScreenEnabled == true {
                lockScreen.isEnabled = false
            } else {
                lockScreen.isEnabled = true
            }
        }
    }
}

#Preview {
    LockScreenSetting()
}
