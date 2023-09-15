import SwiftUI
import RealityKit

protocol ShopItemAttribute: View, Identifiable {
    associatedtype Value
    
    var entity: RealityKit.Entity? { get }
    var name: String { get }
    var value: Value { get nonmutating set }
}

extension ShopItemAttribute {
    var projectedValue: Binding<Value> {
        .init(get: { value }, set: { value = $0 })
    }
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

extension Library {
    struct Color: ShopItemAttribute {
        var entity: RealityKit.Entity?
        var name: String = ""
        
        var value: SwiftUI.Color {
            get {
                guard
                    let attributeEntity = entity?.findEntity(named: name),
                    let material = attributeEntity.shaderGraphMaterial
                else { return .primary }
                
                guard case .color(let value) = material.getParameter(name: "Color") else { return .primary }
                return SwiftUI.Color(cgColor: value)
            }
            
            nonmutating set {
                guard
                    let attributeEntity = entity?.findEntity(named: name),
                    let material = attributeEntity.shaderGraphMaterial
                else { return }
                
                if var component = attributeEntity.modelComponent {
                    component.materials = [material]
                    attributeEntity.components.set(component)
                }
                
                attributeEntity.update(shaderGraphMaterial: material) { mat in
                    try! mat.setParameter(name: "Color", value: .color(UIColor(newValue)))
                }
            }
        }
        
        var body: some View {
            ColorPicker(name, selection: projectedValue)
        }
    }
}
