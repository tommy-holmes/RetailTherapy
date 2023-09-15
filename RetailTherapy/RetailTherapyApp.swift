import SwiftUI
import RealityKitContent

@main
struct RetailTherapyApp: App {
    @State private var model = StoreModel()
    
    init() {
        RealityKitContent.BottleCustomizeSystem.registerSystem()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(model)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .environment(model)
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
