import SwiftUI
import RealityKitContent

@main
struct RetailTherapyApp: App {
    @State private var model = StoreModel()
    
    init() {
        RealityKitContent.CustomizableItemComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            ShopListSplitView()
                .frame(minWidth: 800)
        }
        .environment(model)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .environment(model)
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
