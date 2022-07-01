import SwiftUI

/// A model that describes a control that displays an alert with text fields.
public struct TextFieldAlert {
    /// A model that describes a control that displays an editable text interface.
    public struct TextField {
        let text: Binding<String>
        let placeholder: String?
        let isSecureTextEntry: Bool
        let autocapitalizationType: UITextAutocapitalizationType
        let autocorrectionType: UITextAutocorrectionType
        let keyboardType: UIKeyboardType
        
        /// Creates a model that describes a control that displays an editable text interface.
        /// - Parameters:
        ///   - text: The text to display and edit.
        ///   - placeholder: The string that displays when there is no other text in the text field.
        ///   - isSecureTextEntry: A Boolean value that indicates whether a text object disables copying, and in some cases, prevents recording/broadcasting and also hides the text.
        ///   - autocapitalizationType: The autocapitalization style for the text object.
        ///   - autocorrectionType: The autocorrection style for the text object.
        ///   - keyboardType: The keyboard type for the text object.
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
    
    /// A model that describes an action that can be taken when the user taps a button in an alert.
    public struct Action {
        let title: String
        let style: UIAlertAction.Style
        let isEnabled: Binding<Bool>
        let closure: (([String]) -> Void)?
        
        /// Creates a model that describes an action that can be taken when the user taps a button in an alert.
        /// - Parameters:
        ///   - title: The text to use for the button title.
        ///   - style: Additional styling information to apply to the button.
        ///   - isEnabled: A binding to a Boolean value indicating whether the action is currently enabled.
        ///   - closure: A block to execute when the user selects the action. This block has no return value and takes an array of typed texts as its only parameter.
        public init(
            title: String,
            style: UIAlertAction.Style = .default,
            isEnabled: Binding<Bool> = .constant(true),
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
    
    /// Creates a model that describes a control that displays an alert with text fields.
    /// - Parameters:
    ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    ///   - textFields: The array of text fields displayed by the alert.
    ///   - actions: The actions that the user can take in response to the alert or action sheet.
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
            action.isEnabled = actions[offset].isEnabled.wrappedValue
        }
    }
}
