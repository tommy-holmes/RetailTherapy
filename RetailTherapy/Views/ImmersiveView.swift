import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(StoreModel.self) private var model
    
    @State private var attatchmentsProvider = AttatchmentsProvider()
    @State private var subscriptions: [EventSubscription] = []
    
//    static private let itemsQuery = EntityQuery(where: .has(CustomizableItemComponent.self))
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
                
                let storeEntity = try await Entity(named: "Shop", in: realityKitContentBundle)
                
                model.rootEntity = storeEntity
                
                content.add(storeEntity)
                content.add(generateSkybox())
                
                let resource = try await EnvironmentResource(named: "ImageBasedLight")
                storeEntity.components.set(ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.2))
                storeEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: storeEntity))
            } catch {
                print("Error in RealityView's make: \(error)")
            }
            
        } update: { content, attatchments in
            // TODO: Add labels to the shop items
            
            model.rootEntity?.scene?.performQuery(Self.runtimeQuery).forEach { entity in
                guard let component = entity.components[CustomizableItemRuntimeComponent.self] else { return }
                guard let attachmentEntity = attatchments.entity(for: component.attachmentTag) else { return }
                
                model.rootEntity?.addChild(attachmentEntity)
                attachmentEntity.setPosition([0, 0.75, 0], relativeTo: entity)
            }
            
        } attachments: {
            ForEach(attatchmentsProvider.sortedTagViewPairs, id: \.tag) { pair in
                Attachment(id: pair.tag) {
                    pair.view
                }
            }
        }
    }
    
    private func createItemModel(for entity: Entity) {
        guard entity.components[CustomizableItemRuntimeComponent.self] == nil else { return }
        guard let component = entity.components[CustomizableItemComponent.self] else { return }
        
        let tag: ObjectIdentifier = entity.id
        let view = LabelView(label: component.assetName)
        
        Task {
            let item: ShopItem = switch component.itemType {
            case .bottle: await .bottle()
            case .notebook: await .notebook()
            case .mug: await .mug()
            }
            await entity.children.append(item.entity)
            model.items.append(item)
        }
//        entity.components.set(GroundingShadowComponent(castsShadow: true))
        entity.components.set(CustomizableItemRuntimeComponent(attachmentTag: tag))
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
    
    private struct LabelView: View {
        let label: String
        
        var body: some View {
            Text(label)
                .padding(.horizontal)
                .font(.system(size: 96, weight: .semibold))
                .padding()
                .glassBackgroundEffect()
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
