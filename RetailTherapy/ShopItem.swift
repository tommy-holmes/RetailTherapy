import SwiftUI
import RealityKit
import RealityKitContent

struct ShopItem: Identifiable {
    var entity: RealityKit.Entity
    var entities: [Library.Entity]
    
    init(named name: String, @EntityBuilder entities: () async -> [Library.Entity]) async throws {
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
        try! await ShopItem(named: "Bottle") {
            Library.Entity(named: "cork") {
                Library.Color(name: "Cork Colour")
            }
            Library.Entity(named: "body") {
                Library.Color(name: "Body Colour")
            }
        }
    }
    
    static var notebook: () async -> Self = {
        try! await ShopItem(named: "Notebook") {
            Library.Entity(named: "libro") {
                Library.Color(name: "Cover Colour")
            }
        }
    }
    
    static var whiskey: () async -> Self = {
        try! await ShopItem(named: "Whiskey") {
            Library.Entity(named: "cap_1") {
                Library.Color(name: "Cap Colour")
            }
            Library.Entity(named: "liquid_1") {
                Library.Color(name: "Liquid Colour")
            }
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
