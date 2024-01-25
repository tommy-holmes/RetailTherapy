import SwiftUI
import RealityKit
import RealityKitContent

struct ShopItem: Identifiable {
    let name: String
    var entity: RealityKit.Entity
    var entities: [Library.Entity]
    
    init(named name: String, @EntityBuilder entities: () async -> [Library.Entity]) async throws {
        self.name = name
        let entity = try await RealityKit.Entity(named: name, in: realityKitContentBundle)
        
        self.entities = await entities().map {
            $0.withEntity(entity)
        }
        self.entity = entity
    }
    
    var attributes: [some ShopItemAttribute] {
        entities.flatMap {
            $0.attributes.map { AnyShopItemAttribute($0) }
        }
    }
    
    var id: ObjectIdentifier { entity.id }
}

extension ShopItem {
    static var bottle: () async -> Self = {
        try! await ShopItem(named: "Moo Bottle") {
            Library.Entity(named: "cap") {
                Library.Color(name: "Cap Colour")
            }
            Library.Entity(named: "handle") {
                Library.Color(name: "Handle Colour")
            }
            Library.Entity(named: "bands") {
                Library.Color(name: "Bands Colour")
            }
            Library.Entity(named: "logo") {
                Library.Color(name: "Logo Colour")
            }
        }
    }
    
    static var notebook: () async -> Self = {
        try! await ShopItem(named: "Notebook") {
            Library.Entity(named: "Notebook_geometry") {
                Library.Color(name: "Cover Colour")
            }
            Library.Entity(named: "Logo_geometry") {
                Library.Color(name: "Logo Colour")
            }
        }
    }
    
    static var mug: () async -> Self = {
        try! await ShopItem(named: "Mug") {
            Library.Entity(named: "body") {
                Library.Color(name: "Body Colour")
            }
        }
    }
    
    static var car: () async -> Self = {
        try! await ShopItem(named: "Car") {
            
        }
    }
}

struct Library { }

extension Library {
    struct Entity {
        fileprivate var entity: RealityKit.Entity?
        let name: String
        var attributes: [any ShopItemAttribute]
        
        init(named name: String, @AttributeBuilder _ attributes: () -> [any ShopItemAttribute]) {
            self.name = name
            self.attributes = attributes()
        }
        
        func withEntity(_ entity: RealityKit.Entity) -> Self {
            guard let child = entity.findEntity(named: name) else {
                print("Couldn't find child entity \(name)")
                return self
            }
            
            var copy = self
            copy.entity = entity
            
            copy.attributes = copy.attributes.map {
                $0.with(entity: child)
            }
            return copy
        }
    }
}

@resultBuilder
struct EntityBuilder {
    static func buildBlock(_ components: Library.Entity...) -> [Library.Entity] {
        components
    }
}

@resultBuilder
struct AttributeBuilder {
    typealias Attribute = ShopItemAttribute
    static func buildBlock(_ components: (any Attribute)...) -> [any Attribute] {
        components
    }
}
