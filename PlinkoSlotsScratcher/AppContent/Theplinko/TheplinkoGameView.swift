import SwiftUI
import SpriteKit

struct TheplinkoGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userModel: UserModel
    @State var plinkoScene: TheplinkoGameScene!
    
    var body: some View {
        VStack {
            if let plinkoScene = plinkoScene {
                SpriteView(scene: plinkoScene)
                    .ignoresSafeArea()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("exit_game")), perform: { _ in
            presMode.wrappedValue.dismiss()
            userModel.balance = UserDefaults.standard.integer(forKey: "balance")
        })
        .onAppear {
            plinkoScene = TheplinkoGameScene()
        }
    }
}

#Preview {
    TheplinkoGameView()
}
