import SwiftUI

struct ContentView: View {
    
    @StateObject var userModel: UserModel = UserModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            exit(0)
                        } label: {
                            Image("exit-button")
                                
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: EmptyView()) {
                            Image("settings-button")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    Spacer()
                }
                
                VStack {
                    ZStack {
                        Image("balance-back")
                        Text("\(userModel.balance)")
                            .font(.custom("TitanOne", size: 24))
                            .foregroundColor(.white)
                            .offset(x: 30)
                    }
                    .offset(x: 90)
                    HStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        
//                        NavigationLink(destination: ShopView()) {
//                            Image("cart-button")
//                        }
//                        .padding(.trailing, 32)
                        NavigationLink(destination: GameListView()
                            .environmentObject(userModel)
                            .navigationBarBackButtonHidden()) {
                            Image("pl-button")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                        }
                        .padding(.trailing, 32)
                        NavigationLink(destination: DailyRewardsView()
                            .environmentObject(userModel)
                            .navigationBarBackButtonHidden()) {
                            Image("achivement-button")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                        }
                        .padding(.trailing, 32)
                        
                        Spacer()
                    }
                    .padding(.top)
                    
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Image("girl")
                        Spacer()
                    }
                }
                .ignoresSafeArea()
            }
            .background(
                Image("main_background_image")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height + 20)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
