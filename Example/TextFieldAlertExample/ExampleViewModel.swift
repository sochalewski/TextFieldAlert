import Combine

final class ExampleViewModel: ObservableObject {
    @Published var isPresented = false
    @Published var mail = ""
    @Published var password = ""
    
    var isValid: Bool {
        !mail.isEmpty && password.count >= 5
    }
    
    func presentSignInAlert() {
        mail.removeAll()
        password.removeAll()
        
        isPresented = true
    }
    
    func signIn() {
        print("Signing in with email address '\(mail)' and password '\(password)'…")
    }
}
