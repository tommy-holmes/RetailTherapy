import SwiftUI

public extension View {
    func isHidden(_ hidden: Bool) -> some View {
        self.modifier(IsHiddenModifier(isHidden: hidden))
    }
}

private struct IsHiddenModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        if isHidden {
            content.hidden()
        } else {
            content
        }
    }
}
