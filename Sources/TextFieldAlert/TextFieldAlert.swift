import SwiftUI

public struct TextFieldAlert {
    public struct TextField {
        @Binding var text: String
        let placeholder: String?
        let isSecureTextEntry: Bool
        let autocapitalizationType: UITextAutocapitalizationType
        let keyboardType: UIKeyboardType
        
        public init(
            text: Binding<String> = .constant(""),
            placeholder: String? = nil,
            isSecureTextEntry: Bool = false,
            autocapitalizationType: UITextAutocapitalizationType = .sentences,
            keyboardType: UIKeyboardType = .default
        ) {
            self._text = text
            self.placeholder = placeholder
            self.isSecureTextEntry = isSecureTextEntry
            self.autocapitalizationType = autocapitalizationType
            self.keyboardType = keyboardType
        }
    }
    
    public struct Action {
        let title: String?
        let style: UIAlertAction.Style
        let isEnabled: Published<Bool>.Publisher?
        var closure: (([String]) -> Void)?
        
        public init(
            title: String?,
            style: UIAlertAction.Style = .default,
            isEnabled: Published<Bool>.Publisher? = nil,
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
    ) { }
}
