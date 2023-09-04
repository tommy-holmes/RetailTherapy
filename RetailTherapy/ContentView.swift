import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(StoreModel.self) private var model
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        @Bindable var model = model
        
        NavigationSplitView {
            List(model.items, selection: $model.selectedItem) { item in
                Text(item.name)
                    .tag(item)
            }
            .navigationTitle("Shop Items")
            
        } detail: {
            ScrollView {
                VStack(spacing: 20) {
                    Text(model.selectedItem == nil ? "Choose an item." : "Customise your item.")
                    
                    if model.selectedItem != nil {
                        ColorPicker("Cork Color", selection: $model.selectedCorkColor)
                            .onChange(of: model.selectedCorkColor) { _, _ in
                                model.updateItemMaterial(for: .cork)
                            }
                        
                        ColorPicker("Body Color", selection: $model.selectedBodyColor)
                            .onChange(of: model.selectedBodyColor) { _, _ in
                                model.updateItemMaterial(for: .body)
                            }
                    }
                }
            }
            .navigationTitle("Customise \(model.selectedItem?.name ?? "")")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        model.showImmersiveSpace.toggle()
                        
                        Task {
                            if model.showImmersiveSpace {
                                await openImmersiveSpace(id: "ImmersiveSpace")
                            } else {
                                await dismissImmersiveSpace()
                            }
                        }
                    } label: {
                        Label("View your shop", systemImage: "bag")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
        .environment(StoreModel())
}
