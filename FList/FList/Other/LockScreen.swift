import SwiftUI

struct LockScreen: View {
    var body: some View {
        Button {
            
        } label: {
            Text("Unlock")
                .font(.system(size: 20))
                .bold()
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    LockScreen()
}
