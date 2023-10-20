import SwiftUI

struct ShopListSplitView: View {
    @Environment(StoreModel.self) private var model
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var selectedScheme: ShopScheme = .louisVitton

    var body: some View {
        @Bindable var model = model
        
        NavigationSplitView {
            List(model.items, id: \.entity.id, selection: $model.selectedItem) { item in
                Text(item.name)
                    .tag(item.id)
            }
            .navigationTitle(model.showingImmersiveSpace ? selectedScheme.name : "Shop")
            
        } detail: {
            ScrollView {
                if model.showingImmersiveSpace {
                    VStack(spacing: 20) {
                        Text("Customise your item.")
                        
                        if let selectedItem = model.item(id: model.selectedItem) {
                            ForEach(selectedItem.attributes) { attribute in
                                attribute
                            }
                        }
                    }
                } else {
                    let columns = [
                        GridItem(.adaptive(minimum: 200)),
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        GridRow {
                            ForEach(ShopScheme.mocks) { scheme in
                                let isSelected = scheme == selectedScheme
                                
                                Button {
                                    selectedScheme = scheme
                                } label: {
                                    VStack {
                                        Image(scheme.logo)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(minWidth: 100)
                                            .padding()
                                        
                                        Text(scheme.name)
                                        
                                        if isSelected {
                                            Text("(Selected)")
                                        }
                                    }
                                    .padding()
                                }
                                .disabled(isSelected)
                                .frame(height: 200)
                            }
                        }
                    }
                }
            }
            .navigationTitle(
                model.showingImmersiveSpace
                ? "Customise \(model.item(id: model.selectedItem)?.name ?? "")"
                : "Select shop scheme"
            )
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        model.showingImmersiveSpace.toggle()
                        
                        Task {
                            if model.showingImmersiveSpace {
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
    ShopListSplitView()
        .environment(StoreModel())
}
