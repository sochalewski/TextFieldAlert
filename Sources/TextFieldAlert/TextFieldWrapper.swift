import SwiftUI

struct TextFieldWrapper<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert
    
    var body: some View {
        ZStack {
            if isPresented {
                content().dismissible($isPresented)
            }
            
            presentingView
        }
    }
}
