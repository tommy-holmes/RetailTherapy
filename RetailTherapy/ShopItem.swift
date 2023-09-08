import SwiftUI
import RealityKit

protocol ShopItem {
    associatedtype Part: Hashable, RawRepresentable where Part.RawValue == String
    
    var entity: Entity { get }
    var parts: [Part: Color] { get }
    
    mutating func updateColor(for part: Part, to newColor: Color) -> Void
}

struct Bottle: ShopItem {
    enum Part: String {
        case body
        case cork
    }
    
    let entity: Entity
    private(set) var parts: [Part: Color]
    
    init(bodyColor: Color, corkColor: Color) async {
        self.entity = try! await Entity(named: "Bottle")
        self.parts = [
            .body: bodyColor,
            .cork: corkColor,
        ]
    }
    
    mutating func updateColor(for part: Part, to newColor: Color) {
        parts[part] = newColor
        refresh()
    }
}

struct TShirt: ShopItem {
    enum Part: String {
        case body
        case chest
    }
    
    let entity: Entity
    private(set) var parts: [Part: Color]
    
    init(bodyColor: Color, chestColor: Color) async {
        self.entity = try! await Entity(named: "TShirt")
        self.parts = [
            .body: bodyColor,
            .chest: chestColor,
        ]
    }
    
    mutating func updateColor(for part: Part, to newColor: Color) {
        parts[part] = newColor
        refresh()
    }
}

private extension ShopItem {
    func refresh() {
        let partKeys = parts.keys.compactMap { $0 as Part }
        
        partKeys.forEach { part in
            guard
                let partEntity = entity.findEntity(named: part.rawValue),
                let material = partEntity.shaderGraphMaterial
            else { return }
            
            if var component = partEntity.modelComponent {
                component.materials = [material]
                partEntity.components.set(component)
            }
            
            partEntity.update(shaderGraphMaterial: material) { mat in
                try! mat.setParameter(name: "Color", value: .color(UIColor(parts[part]!)))
            }
        }
    }
}

struct Foo {
    func bar() async  {
        var bottle = await Bottle(bodyColor: .blue, corkColor: .black)
        bottle.updateColor(for: .cork, to: .orange)
    }
}
