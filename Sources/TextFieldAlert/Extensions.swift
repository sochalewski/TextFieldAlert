import SwiftUI
import UIKit
import Combine

public extension View {
    func textFieldAlert(
        title: String?,
        message: String? = nil,
        textFields: [TextFieldAlert.TextField],
        actions: [TextFieldAlert.Action],
        isPresented: Binding<Bool>,
        alwaysPreferUIKit: Bool = false
    ) -> some View {
        if #available(iOS 16, *), !alwaysPreferUIKit {
            return AnyView(
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
                                action.title ?? "",
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
            )
        } else {
            return AnyView(
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
