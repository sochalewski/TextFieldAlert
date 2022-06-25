import SwiftUI

public struct TextFieldAlert {
    public struct TextField {
        let text: Binding<String>
        let placeholder: String?
        let isSecureTextEntry: Bool
        let autocapitalizationType: UITextAutocapitalizationType
        let autocorrectionType: UITextAutocorrectionType
        let keyboardType: UIKeyboardType
        
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
    
    public struct Action {
        let title: String?
        let style: UIAlertAction.Style
        let isEnabled: Binding<Bool>
        let closure: (([String]) -> Void)?
        
        public init(
            title: String?,
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
