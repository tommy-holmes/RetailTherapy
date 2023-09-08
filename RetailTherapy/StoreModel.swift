import SwiftUI
import Observation
import RealityKit
import RealityKitContent

enum BottlePart: String {
    case cork
    case body
}

@Observable
class StoreModel {
    
    var rootEntity: Entity?
    var showImmersiveSpace = false
    // To change to `ShopItem`
    var selectedItem: Entity?
    
    // To get rid of:
    var selectedCorkColor: Color = .white
    var selectedBodyColor: Color = .blue
    
    // To change to `[ShopItem]`
    var items: [Entity] = []
    
//    func getMaterialValue(for part: BottlePart) -> CGColor? {
//        guard case .color(let value) = selectedItem?
//            .findEntity(named: part.rawValue)?
//            .shaderGraphMaterial?
//            .getParameter(name: "Color") else { return nil }
//        return value
//    }
    
//    func update(selected entity: Entity) {
//        selectedItem = entity
//        
//        if let selectedItemMaterialValue {
//            selectedColor = Color(cgColor: selectedItemMaterialValue)
//        }
//    }
    
    func updateItemMaterial(for part: BottlePart) {
        guard
            let entity = selectedItem?.findEntity(named: part.rawValue),
            let material = entity.shaderGraphMaterial
        else { return }
        
        if var component = entity.modelComponent {
            component.materials = [material]
            entity.components.set(component)
        }
        
        entity.update(shaderGraphMaterial: material) { mat in
            switch part {
            case .cork:
                try! mat.setParameter(name: "Color", value: .color(UIColor(selectedCorkColor)))
            case .body:
                try! mat.setParameter(name: "Color", value: .color(UIColor(selectedBodyColor)))
            }
        }
    }
}
