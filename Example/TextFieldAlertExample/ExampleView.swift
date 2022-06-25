import SwiftUI
import TextFieldAlert

struct ExampleView: View {
    @StateObject var viewModel = ExampleViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Button {
                viewModel.presentSignInAlert()
            } label: {
                Text("Sign in")
            }
            
            Spacer()
            Spacer()
            
            Text("Mail: \(viewModel.mail)")
            Text("Password: \(viewModel.password)")
            
            Spacer()
        }
        .textFieldAlert(
            title: "Sign in",
            message: "Enter the following information.",
            textFields: [
                .init(
                    text: $viewModel.mail,
                    placeholder: "Email address (cannot be empty)",
                    autocapitalizationType: .none,
                    keyboardType: .emailAddress
                ),
                .init(
                    text: $viewModel.password,
                    placeholder: "Password (5 characters or more)",
                    isSecureTextEntry: true,
                    autocapitalizationType: .none
                )
            ],
            actions: [
                .init(
                    title: "Cancel",
                    style: .cancel
                ),
                .init(
                    title: "OK",
                    isEnabled: $viewModel.isValid,
                    closure: { _ in
                        viewModel.signIn()
                    }
                )
            ],
            isPresented: $viewModel.isPresented
        )
    }
}

struct ExampleViewPreviews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
