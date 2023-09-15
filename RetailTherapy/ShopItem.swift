import SwiftUI
import RealityKit
import RealityKitContent

struct ShopItem {
    var entity: RealityKit.Entity
    var entities: [Library.Entity]
    
    init(named name: String, @EntityBuilder entities: () -> [Library.Entity]) async throws {
        let entity = try await RealityKit.Entity(named: name, in: realityKitContentBundle)
        self.entities = entities().map { $0.withEntity(entity) }
        self.entity = entity
    }
    
    var attributes: [AnyShopItemAttribute] {
        var attributes: [AnyShopItemAttribute] = []
        for entity in entities {
            for attribute in entity.attributes {
                attributes.append(
                    AnyShopItemAttribute(
                        attribute,
                        entity: entity.entity,
                        name: entity.name
                    )
                )
            }
        }
        return attributes
    }
}

extension ShopItem: Hashable {
    static func == (lhs: ShopItem, rhs: ShopItem) -> Bool {
        lhs.entity == rhs.entity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(entity)
    }
}

struct Library { }

extension Library {
    struct Entity {
        fileprivate var entity: RealityKit.Entity?
        let name: String
        let attributes: [any ShopItemAttribute]
        
        init(named name: String, @AttributeBuilder _ attributes: () -> [any ShopItemAttribute]) {
            self.name = name
            self.attributes = attributes()
        }
        
        func withEntity(_ entity: RealityKit.Entity) -> Self {
            var copy = self
            copy.entity = entity
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
