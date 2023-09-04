import RealityKit
import SwiftUI

public final class BottleCustomizeSystem: System {
    
    static let query = EntityQuery(where: .has(CustomizableItemComponent.self))
    
    private static let bodyColorName = "BodyColor"
    private static let corkColorName = "CorkColor"
    
    public init(scene: RealityKit.Scene) { }
    
    public var bodyColor: Color = .blue
    public var corkColor: Color = .white
    
    public func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            guard var material = entity.shaderGraphMaterial else { return }
            
            try! material.setParameter(name: Self.bodyColorName, value: .color(bodyColor.cgColor!))
            try! material.setParameter(name: Self.corkColorName, value: .color(corkColor.cgColor!))
            
            if var component = entity.modelComponent {
                component.materials = [material]
                entity.components.set(component)
            }
        }
    }
}
