import SwiftUI
import RealityKit
import RealityKitContent

@Observable
class StoreModel {
    
    var rootEntity: Entity?
    var showImmersiveSpace = false
    var selectedItem: ShopItem?
    
    var items: [ShopItem] = []
    
    //    var hashableItems: [AnyShopItem] {
    //        items.map { AnyShopItem($0) }
    //    }
}

//protocol ShopItemPart {
//    var entity: Entity { get }
//    var name: String { get }
//}

////struct AnyShopItem: ShopItem {
////    typealias Part = Item.Part
////    
////    var wrapped: Item
////    
////    var parts: [Item.Part : Color]
////    var entity: Entity
////    
////    init(_ wrapped: Item) {
////        self.wrapped = wrapped
////        
////        entity = wrapped.entity
////        parts = wrapped.parts
////    }
////    
////    mutating func updateColor(for part: Item.Part, to newColor: Color) {
////        wrapped.updateColor(for: part, to: newColor)
////    }
////}
//
//struct Bottle: ShopItem {
//    
//    enum Part: String, Identifiable, CaseIterable, ShopItemPart {
//        case body
//        case cork
//        
//        var id: Self { self }
//        var name: String { rawValue }
//    }
//    
//    let entity: Entity
//    
//    var parts: [Part] = Part.allCases
//    
//    init() async {
//        self.entity = try! await Entity(named: "Bottle", in: realityKitContentBundle)
//        refresh()
//    }
//}
//
//struct ColorPart: ShopItemPart {
//    var name: String
//    var entity: Entity
//    
//    var color: Color? {
//        get {
//            guard
//                let partEntity = entity.findEntity(named: name),
//                let material = partEntity.shaderGraphMaterial
//            else { return nil }
//            
//            if var component = partEntity.modelComponent {
//                component.materials = [material]
//                partEntity.components.set(component)
//            }
//            
//            guard case .color(let value) = material.getParameter(name: "Color") else { return nil }
//            return Color(cgColor: value)
//        } set {
//            // tbd
//        }
//    }
//}
//
//private extension Entity {
//    func color(for part: ShopItemPart) -> Color? {
//        guard
//            let partEntity = findEntity(named: part.name),
//            let material = partEntity.shaderGraphMaterial
//        else { return nil }
//        
//        guard case .color(let value) = material.getParameter(name: "Color") else { return nil }
//        return Color(cgColor: value)
//    }
//}
//
//private extension ShopItem {
//    func refresh() {
//        parts.forEach { part in
//            guard
//                let partEntity = entity.findEntity(named: part.name),
//                let material = partEntity.shaderGraphMaterial
//            else { return }
//            
//            if var component = partEntity.modelComponent {
//                component.materials = [material]
//                partEntity.components.set(component)
//            }
//            
//            partEntity.update(shaderGraphMaterial: material) { mat in
//                try! mat.setParameter(name: "Color", value: .color(UIColor(part.color)))
//            }
//        }
//    }
//}
