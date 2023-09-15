import SwiftUI

struct ContentView: View {
    @Environment(StoreModel.self) private var model
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        @Bindable var model = model
        
        NavigationSplitView {
            List(model.items, id: \.entity.id, selection: $model.selectedItem) { item in
//                List(selection: $model.selectedItem) {
                    Text(item.entity.name)
                        .tag(item)
//                }
            }
            .navigationTitle("Shop Items")
            
        } detail: {
            ScrollView {
                VStack(spacing: 20) {
                    Text(model.selectedItem == nil ? "Choose an item." : "Customise your item.")
                    
                    if model.selectedItem != nil {
                        ForEach(model.selectedItem!.attributes) { attribute in
                            attribute
                        }
                    }
                }
            }
            .navigationTitle("Customise \(model.selectedItem?.entity.name ?? "")")
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
