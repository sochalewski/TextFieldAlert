import SwiftUI

struct TextFieldWrapper<PresentingView: View>: View {
    @Binding private var isPresented: Bool
    private let presentingView: PresentingView
    private let alert: TextFieldAlert
    
    init(
        isPresented: Binding<Bool>,
        presentingView: PresentingView,
        alert: TextFieldAlert
    ) {
        self._isPresented = isPresented
        self.presentingView = presentingView
        self.alert = alert
    }
    
    var body: some View {
        presentingView
            .background(
                Group {
                    if isPresented {
                        alert.dismissible($isPresented)
                    }
                }
            )
    }
}
