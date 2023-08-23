import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var model = StoreModel()
    @State private var attatchmentsProvider = AttatchmentsProvider()
    @State private var subscriptions: [EventSubscription] = []
    @State private var showingCustomize: Bool = false
    
    static private let itemsQuery = EntityQuery(where: .has(CustomizableItemComponent.self))
    static private let runtimeQuery = EntityQuery(where: .has(CustomizableItemRuntimeComponent.self))
    
    var body: some View {
        RealityView { content, _ in
            do {
                subscriptions.append(content.subscribe(
                    to: ComponentEvents.DidAdd.self,
                    componentType: CustomizableItemComponent.self
                ) { event in
                    createItemModel(for: event.entity)
                })
                
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
                
                if showingCustomize {
                    model.rootEntity?.addChild(attachmentEntity)
                }
                attachmentEntity.setPosition([-0.75, 0, 0], relativeTo: entity)
            }
            
        } attachments: {
            ForEach(attatchmentsProvider.sortedTagViewPairs, id: \.tag) { pair in
                pair.view
            }
        }
    }
    
    private func createItemModel(for entity: Entity) {
        guard entity.components[CustomizableItemRuntimeComponent.self] == nil else { return }
//        guard let item = entity.components[CustomizableItemComponent.self] else { return }
        
        let tag: ObjectIdentifier = entity.id
        
        Task {
            let bottleEntity = try! await Entity(named: "Bottle", in: realityKitContentBundle)
            await entity.children.append(bottleEntity, preservingWorldTransform: false)
//            bottleEntity.components[ModelComponent.self]
        }
        
        let view = CustomizeView()
        
        entity.components[CustomizableItemRuntimeComponent.self] = CustomizableItemRuntimeComponent(attachmentTag: tag)
        attatchmentsProvider.attachments[tag] = AnyView(view)
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
