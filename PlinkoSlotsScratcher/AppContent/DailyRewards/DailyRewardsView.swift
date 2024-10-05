import SwiftUI

struct DailyRewardsView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userModel: UserModel
    @StateObject var dailyRewardsVM = DailyManager()
    @State var claimBonusAlertSuccess: Bool = false
    @State var claimBonusAlertVisible: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("exit-button")
                }
                
                Spacer()
                
                Text("DAILY REWARDS")
                    .font(.custom("TitanOne", size: 32))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image("settings-button")
                    .opacity(0)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        Button {
                            if dailyRewardsVM.claimBonus() {
                                userModel.balance += dailyRewardsVM.getBonusAmountFor(day: day)
                                claimBonusAlertSuccess = true
                            } else {
                                claimBonusAlertSuccess = false
                            }
                            claimBonusAlertVisible = true
                        } label: {
                            ZStack {
                                Image("card_back")
                                    .resizable()
                                    .frame(width: 180, height: 180)
                                VStack {
                                    Text("DAY \(day)")
                                        .font(.custom("TitanOne", size: 24))
                                        .foregroundColor(.white)
                                    
                                    switch dailyRewardsVM.getBonusAmountFor(day: day) {
                                    case 5000, 10000:
                                        Image("coin")
                                    case 15000, 20000:
                                        Image("coin3")
                                    case 25000, 30000:
                                        Image("coin5")
                                    case 35000:
                                        Image("coin10")
                                    default:
                                        EmptyView()
                                    }
                                }
                                Image("get_button")
                                    .resizable()
                                    .frame(width: 80, height: 40)
                                    .offset(y: 90)
                            }
                            .padding(.trailing)
                        }
                        .opacity(dailyRewardsVM.isBonusAvailable(for: day) ? 1 : 0.6)
                        .disabled(!dailyRewardsVM.isBonusAvailable(for: day))
                    }
                }
                .frame(height: 250)
            }
            
            Spacer()
            
        }
        .alert(isPresented: $claimBonusAlertVisible, content: {
            if claimBonusAlertSuccess {
                Alert(title: Text("Claim success!"))
            } else {
                Alert(title: Text("Claim failed!"),
                message: Text("This bonus is unavailable! Try again tomorow!"))
            }
        })
        .background(
            Image("main_background_image")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height + 20)
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    VStack {
        DailyRewardsView()
            .environmentObject(UserModel())
    }
}
