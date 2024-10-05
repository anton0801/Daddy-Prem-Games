import Foundation

class UserModel: ObservableObject {
    
    @Published var balance: Int = UserDefaults.standard.integer(forKey: "balance") {
        didSet {
            UserDefaults.standard.set(balance, forKey: "balance")
        }
    }
    
}
