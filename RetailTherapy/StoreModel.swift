import SwiftUI
import Observation
import RealityKit
import RealityKitContent

struct Test: View {
    @State private var bottle: ShopItem?
    
    var body: some View {
        Group {
            if let bottle {
                ForEach(bottle.attributes) { attribute in
                    attribute
                }
            }
        }
        .task {
            do {
                bottle = try await ShopItem(named: "Bottle") {
                    Library.Entity(named: "cork") {
                        Library.Color()
                    }
                }
            } catch { }
        }
    }
}

struct ShopItem {
    private let entity: RealityKit.Entity
    var entities: [Library.Entity]
    
    init(named name: String, @EntityBuilder entities: () -> [Library.Entity]) async throws {
        let entity = try await RealityKit.Entity(named: "Bottle", in: realityKitContentBundle)
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

extension Library {
    struct Color: ShopItemAttribute {
        var entity: RealityKit.Entity?
        var name: String = ""
        
        var value: SwiftUI.Color {
            get {
                guard
                    let partEntity = entity?.findEntity(named: name),
                    let material = partEntity.shaderGraphMaterial
                else { return .primary }
                
                guard case .color(let value) = material.getParameter(name: "Color") else { return .primary }
                return SwiftUI.Color(cgColor: value)
            } nonmutating set {
                
            }
        }
        
        var body: some View {
            ColorPicker(name, selection: projectedValue)
        }
    }
}

extension ShopItemAttribute {
    var projectedValue: Binding<Value> {
        .init(get: { value }, set: { value = $0 })
    }
}

protocol ShopItemAttribute: View, Identifiable {
    associatedtype Value
    var entity: RealityKit.Entity? { get }
    var name: String { get }
    var value: Value { get nonmutating set }
}

extension ShopItemAttribute {
    var id: String { String(describing: self) }
}

struct AnyShopItemAttribute: ShopItemAttribute {
    var entity: RealityKit.Entity?
    var name: String
    
    private var _get: () -> Any
    private var _set: (Any) -> Void
    
    var value: Any {
        get { _get() }
        nonmutating set { _set(newValue) }
    }
    
    private var _body: () -> AnyView
    var body: some View {
        _body()
    }
    
    init<T: ShopItemAttribute>(_ attribute: T, entity: RealityKit.Entity?, name: String) {
        _get = { attribute.value }
        _set = { attribute.value = $0 as! T.Value }
        _body = { .init(attribute.body) }
        self.entity = entity
        self.name = name
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
