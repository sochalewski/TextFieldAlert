import SwiftUI

/// A model that configures an alert with text fields and actions.
public struct TextFieldAlert {
    /// A model that configures a text field displayed in a `TextFieldAlert`.
    public final class TextField: Identifiable {
        let text: Binding<String>
        let placeholder: String?
        let isSecureTextEntry: Bool
        let autocapitalizationType: UITextAutocapitalizationType
        let autocorrectionType: UITextAutocorrectionType
        let keyboardType: UIKeyboardType
        
        /// Creates a model that configures a text field displayed in a `TextFieldAlert`.
        /// - Parameters:
        ///   - text: A binding to the text displayed and edited by the text field.
        ///   - placeholder: The placeholder text displayed when the text field is empty.
        ///   - isSecureTextEntry: A Boolean value that determines whether the text field obscures the entered text.
        ///   - autocapitalizationType: The autocapitalization behavior for the text field.
        ///   - autocorrectionType: The autocorrection behavior for the text field.
        ///   - keyboardType: The keyboard type to display while editing the text field.
        public init(
            text: Binding<String> = .constant(""),
            placeholder: String? = nil,
            isSecureTextEntry: Bool = false,
            autocapitalizationType: UITextAutocapitalizationType = .sentences,
            autocorrectionType: UITextAutocorrectionType = .default,
            keyboardType: UIKeyboardType = .default
        ) {
            self.text = text
            self.placeholder = placeholder
            self.isSecureTextEntry = isSecureTextEntry
            self.autocapitalizationType = autocapitalizationType
            self.autocorrectionType = autocorrectionType
            self.keyboardType = keyboardType
        }
    }
    
    /// A model that configures an action button displayed in a `TextFieldAlert`.
    public final class Action: Identifiable {
        let title: String
        let style: UIAlertAction.Style
        let isEnabled: Bool
        let closure: (([String]) -> Void)?
        
        /// Creates a model that configures an action button displayed in a `TextFieldAlert`.
        /// - Parameters:
        ///   - title: The title of the action button.
        ///   - style: The style of the alert action button.
        ///   - isEnabled: A Boolean value indicating whether the action is enabled.
        ///   - closure: A closure called when the user selects the action. It receives the current text values in the same order as the text fields passed to the alert.
        public init(
            title: String,
            style: UIAlertAction.Style = .default,
            isEnabled: Bool = true,
            closure: (([String]) -> Void)? = nil
        ) {
            self.title = title
            self.style = style
            self.isEnabled = isEnabled
            self.closure = closure
        }
    }
    
    let title: String?
    let message: String?
    let textFields: [TextField]
    let actions: [Action]
    let isPresented: Binding<Bool>?
    
    /// Creates a model that configures an alert with text fields and actions.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: An optional message displayed below the title.
    ///   - textFields: The text fields displayed by the alert.
    ///   - actions: The actions available to the user in the alert.
    public init(
        title: String?,
        message: String? = nil,
        textFields: [TextField] = [],
        actions: [Action] = []
    ) {
        self.title = title
        self.message = message
        self.textFields = textFields
        self.actions = actions
        self.isPresented = nil
    }
    
    init(
        title: String?,
        message: String? = nil,
        textFields: [TextField] = [],
        actions: [Action] = [],
        isPresented: Binding<Bool>?
    ) {
        self.title = title
        self.message = message
        self.textFields = textFields
        self.actions = actions
        self.isPresented = isPresented
    }
    
    func dismissible(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(
            title: title,
            message: message,
            textFields: textFields,
            actions: actions,
            isPresented: isPresented
        )
    }
}

extension TextFieldAlert: UIViewControllerRepresentable {
    public func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> TextFieldAlertViewController {
        TextFieldAlertViewController(alert: self)
    }
    
    public func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: UIViewControllerRepresentableContext<TextFieldAlert>
    ) {
        guard let alertController = uiViewController.presentedViewController as? UIAlertController else { return }
        
        alertController.actions.enumerated().forEach { offset, action in
            action.isEnabled = actions[offset].isEnabled
        }
    }

    public static func dismantleUIViewController(
        _ uiViewController: TextFieldAlertViewController,
        coordinator: Void
    ) {
        uiViewController.dismissAlert()
    }
}
