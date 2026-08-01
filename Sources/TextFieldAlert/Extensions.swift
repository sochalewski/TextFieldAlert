import SwiftUI
import UIKit
import Combine

public extension View {
    /// Presents an alert containing text fields when `isPresented` is `true`.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: An optional message displayed below the title.
    ///   - textFields: The text fields displayed in the alert.
    ///   - actions: The actions displayed in the alert.
    ///   - isPresented: A binding to a Boolean value that controls whether the alert is presented. The binding is set to `false` when the user selects an action.
    ///   - alwaysPreferUIKit: A Boolean value that forces the UIKit-backed implementation when `true`. By default, iOS 17 and later use the native SwiftUI implementation; earlier iOS versions and tvOS use UIKit.
    @ViewBuilder func textFieldAlert(
        title: String?,
        message: String? = nil,
        textFields: [TextFieldAlert.TextField],
        actions: [TextFieldAlert.Action],
        isPresented: Binding<Bool>,
        alwaysPreferUIKit: Bool = false
    ) -> some View {
        if #available(iOS 17, tvOS 100000, *), !alwaysPreferUIKit {
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
                                .autocorrectionDisabled(textField.autocorrectionType == .no)
                                .keyboardType(textField.keyboardType)
                        }
                    }
                    
                    ForEach(actions) { action in
                        Button(
                            action.title,
                            role: action.style.role,
                            action: { action.closure?(textFields.map { $0.text.wrappedValue }) }
                        )
                        .disabled(!action.isEnabled)
                    }
                },
                message: {
                    if let message = message {
                        Text(message)
                    }
                }
            )
        } else {
            TextFieldWrapper(
                isPresented: isPresented,
                presentingView: self,
                alert: TextFieldAlert(
                    title: title,
                    message: message,
                    textFields: textFields,
                    actions: actions
                )
            )
        }
    }
}

extension UIAlertAction.Style {
    @available(iOS 15, tvOS 15, *)
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
