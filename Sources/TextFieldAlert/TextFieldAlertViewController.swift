import UIKit
import SwiftUI
import Combine

public final class TextFieldAlertViewController: UIViewController {
    
    private let alert: TextFieldAlert
    private var cancellables = Set<AnyCancellable>()
    
    init(
        alert: TextFieldAlert
    ) {
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAlertController()
    }
    
    private func presentAlertController() {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )
        
        alert.textFields.forEach { textField in
            alertController.addTextField { [weak self] in
                guard let self = self else { return }
                $0.text = textField.text
                $0.textPublisher.assign(to: \.text, on: textField).store(in: &self.cancellables)
                $0.placeholder = textField.placeholder
                $0.isSecureTextEntry = textField.isSecureTextEntry
                $0.autocapitalizationType = textField.autocapitalizationType
                $0.autocorrectionType = textField.autocorrectionType
                $0.keyboardType = textField.keyboardType
            }
        }
        
        alert.actions.forEach { action in
            let alertAction = CancellableAlertAction(
                title: action.title,
                style: action.style,
                handler: { [weak self, weak alertController] _ in
                    self?.alert.isPresented?.wrappedValue = false
                    action.closure?(alertController?.textFields?.map { $0.text ?? "" } ?? [])
                }
            )
            alertController.addAction(alertAction)
            
            guard let isEnabled = action.isEnabled else { return }
            alertAction.cancellable = isEnabled.assign(to: \.isEnabled, on: alertAction)
        }
        
        present(alertController, animated: true)
    }
}

final class CancellableAlertAction: UIAlertAction {
    var cancellable: AnyCancellable?
}
