import SwiftUI
import UIKit
import Combine

public extension View {
    /// Presents a text field alert when a given condition is true.
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - message: A text string used as the message of the alert.
    ///   - textFields: An array of models used as text fields of the alert.
    ///   - actions: An array of models used as actions of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to present the alert. When the user presses or taps one of the alert's actions, the system sets this value to `false` and dismisses.
    func textFieldAlert(
        title: String?,
        message: String? = nil,
        textFields: [TextFieldAlert.TextField],
        actions: [TextFieldAlert.Action],
        isPresented: Binding<Bool>
    ) -> some View {
        TextFieldWrapper(
            isPresented: isPresented,
            presentingView: self,
            content: {
                TextFieldAlert(
                    title: title,
                    message: message,
                    textFields: textFields,
                    actions: actions
                )
            }
        )
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
