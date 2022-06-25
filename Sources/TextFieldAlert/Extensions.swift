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
    ///   - alwaysPreferUIKit: A Boolean value that determines whether to always prefer an `UIAlertController`-backed view over a native alert on iOS 17 and greater.
    @ViewBuilder func textFieldAlert(
        title: String?,
        message: String? = nil,
        textFields: [TextFieldAlert.TextField],
        actions: [TextFieldAlert.Action],
        isPresented: Binding<Bool>,
        alwaysPreferUIKit: Bool = false
    ) -> some View {
        if #available(iOS 17, *), !alwaysPreferUIKit {
            alert(
                title ?? "",
                isPresented: isPresented,
                actions: {
                    ForEach(textFields) { textField in
                        if textField.isSecureTextEntry {
                            SecureField(textField.placeholder ?? "", text: textField.text)
                        } else {
                            TextField(textField.placeholder ?? "", text: textField.text)
                                .autocapitalization(textField.autocapitalizationType)
                                .disableAutocorrection(textField.autocorrectionType == .no)
                                .keyboardType(textField.keyboardType)
                        }
                    }
                    
                    ForEach(actions) { action in
                        Button(
                            action.title,
                            role: action.style.role,
                            action: { action.closure?(textFields.map { $0.text.wrappedValue }) }
                        )
                        .disabled(!action.isEnabled.wrappedValue)
                    }
                },
                message: {
                    message != nil ? Text(message!) : nil
                }
            )
        } else {
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
}

extension UIAlertAction.Style {
    @available(iOS 15.0, *)
    var role: ButtonRole? {
        switch self {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        case .default:
            fallthrough
        @unknown default:
            return nil
        }
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
