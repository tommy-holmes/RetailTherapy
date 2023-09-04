import SwiftUI
import Observation
import RealityKit
import RealityKitContent

@Observable
class StoreModel {
    
    var rootEntity: Entity? = nil
    var showImmersiveSpace = false
    var selectedItem: Entity?
    var selectedColor: Color = .blue
    
    var items: [Entity] = []
    
//    var materialValue: CGColor? {
//        guard case .color(let value) = bottleMaterial?.getParameter(name: "Color") else { return nil }
//        return value
//    }
    
    private var bottleMaterial: ShaderGraphMaterial? {
        rootEntity?.bottle?.shaderGraphMaterial
    }
    
    func updateItemMaterial() {
        guard let bottle = rootEntity?.findEntity(named: "body"),
                var material = bottle.shaderGraphMaterial
        else { return }
        
        try! material.setParameter(name: "Color", value: .color(.brown))
        
        if var component = bottle.modelComponent {
            component.materials = [material]
            bottle.components.set(component)
        }
        
        bottle.update(shaderGraphMaterial: material) { mat in
            try! mat.setParameter(name: "Color", value: .color(.brown))
        }
    }
}

fileprivate extension Entity {
    var bottle: Entity? {
        findEntity(named: "Bottle")
    }
}
ç
