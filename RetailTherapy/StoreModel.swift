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
    
    var rootEntity: Entity? = nil
    var showImmersiveSpace = false
    var selectedItem: Entity?
    var selectedCorkColor: Color = .white
    var selectedBodyColor: Color = .blue
    
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
