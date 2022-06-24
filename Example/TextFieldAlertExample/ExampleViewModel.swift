import Combine

final class ExampleViewModel: ObservableObject {
    
    @Published var isPresented = false
    @Published var mail = ""
    @Published var password = ""
    @Published var isValid = false
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = Publishers.CombineLatest($mail, $password)
            .sink { value in
                let isMailValid = !value.0.isEmpty
                let isPasswordValid = value.1.count >= 5
                self.isValid = isMailValid && isPasswordValid
            }
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
