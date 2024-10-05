import SwiftUI

struct GameListView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        exit(0)
                    } label: {
                        Image("exit-button")
                    }
                    
                    Spacer()
                    
                    Text("CHOOSE ANY TYPE GAME TO PLAY")
                        .font(.custom("TitanOne", size: 32))
                        .foregroundColor(.white)
                        .offset(x: 30)
                    
                    Spacer()
                    
                    Image("settings-button")
                        .opacity(0)
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: GoldZeusGameView()
                        .environmentObject(userModel)
                        .navigationBarBackButtonHidden()) {
                        Image("gold_zeus")
                    }
                    NavigationLink(destination: TheplinkoGameView()
                        .environmentObject(userModel)
                        .navigationBarBackButtonHidden()) {
                        Image("the_plinko")
                    }
                }
            }
            .preferredColorScheme(.dark)
            .background(
                Image("main_background_image")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height + 20)
                    .opacity(0.7)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GameListView()
        .environmentObject(UserModel())
}
