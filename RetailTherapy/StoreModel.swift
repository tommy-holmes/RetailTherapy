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
    
//    func update(selected entity: Entity) {
//        selectedItem = entity
//        
//        if let selectedItemMaterialValue {
//            selectedColor = Color(cgColor: selectedItemMaterialValue)
//        }
//    }
    
    func updateItemMaterial() {
        guard 
            let bottle = selectedItem?.findEntity(named: "body"),
            let material = bottle.shaderGraphMaterial
        else { return }
        
        if var component = bottle.modelComponent {
            component.materials = [material]
            bottle.components.set(component)
        }
        
        bottle.update(shaderGraphMaterial: material) { mat in
            try! mat.setParameter(name: "Color", value: .color(UIColor(selectedColor)))
        }
    }
}

fileprivate extension Entity {
    var bottle: Entity? {
        findEntity(named: "Bottle")
    }
}

//import SwiftData

//protocol ShopItem: AnyObject {
//    var entity: Entity { get }
//}

//@Model
//class ShopItem<T> {
//    let entity: Entity
//    var colors: [String: Color]
//    
//    init(entity: Entity, colors: [String: Color]) {
//        self.entity = entity
//        self.colors = colors
//    }
//}
