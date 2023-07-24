import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var model = StoreModel()
    @State private var attatchmentsProvider = AttatchmentsProvider()
//    @State private var subscriptions: [EventSubscription] = []
    
    static private let itemsQuery = EntityQuery(where: .has(CustomizableItemComponent.self))
    static private let runtimeQuery = EntityQuery(where: .has(CustomizableItemRuntimeComponent.self))
    
    var body: some View {
        RealityView { content, _ in
            do {
                let storeEntity = try await Entity(named: "Store", in: realityKitContentBundle)
                model.rootEntity = storeEntity
                
                content.add(storeEntity)
                content.add(generateSkybox())
                
            } catch {
                print("Error in RealityView's make: \(error)")
            }
            
        } update: { content, attatchments in
            
            model.rootEntity?.scene?.performQuery(Self.runtimeQuery).forEach { entity in
                guard let component = entity.components[CustomizableItemRuntimeComponent.self] else { return }
                guard let attachmentEntity = attatchments.entity(for: component.attachmentTag) else { return }
                
                content.add(attachmentEntity)
            }
            
        } attachments: {
            ForEach(attatchmentsProvider.sortedTagViewPairs, id: \.tag) { pair in
                pair.view
            }
        }
    }
    
    private func generateSkybox() -> Entity {
        guard let resource = try? TextureResource.load(named: "store_skybox") else {
            fatalError("Unable to load skybox texture.")
        }
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))
        
        let entity = Entity()
        entity.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1000),
            materials: [material]
        ))
        entity.scale *= .init(x: -1, y: 1, z: 1)
        
        return entity
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
