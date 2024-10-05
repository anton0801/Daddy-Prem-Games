import SwiftUI
import SpriteKit

struct GoldZeusGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userModel: UserModel
    @State var goldscene: GoldZeusgGameScene!
    
    var body: some View {
        ZStack {
            if let goldscene = goldscene {
                SpriteView(scene: goldscene)
                    .ignoresSafeArea()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("exit_game")), perform: { _ in
            presMode.wrappedValue.dismiss()
            userModel.balance = UserDefaults.standard.integer(forKey: "balance")
        })
        .onAppear {
            goldscene = GoldZeusgGameScene()
        }
    }
}

#Preview {
    GoldZeusGameView()
        .environmentObject(UserModel())
}
