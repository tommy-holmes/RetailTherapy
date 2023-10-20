import SwiftUI
import RealityKit

protocol ShopItemAttribute: View, Identifiable {
    associatedtype Value: Hashable
    
    var entity: RealityKit.Entity? { get set }
    var name: String { get }
    var value: Value { get nonmutating set }
}

extension ShopItemAttribute {
    var projectedValue: Binding<Value> {
        .init(get: { value }, set: { value = $0 })
    }
    
    func with(entity: RealityKit.Entity) -> Self {
        var copy = self
        copy.entity = entity
        return copy
    }
}

extension ShopItemAttribute {
    var id: String { String(describing: self) }
}

struct AnyShopItemAttribute: ShopItemAttribute {
    var entity: RealityKit.Entity?
    var name: String
    
    private var _get: () -> AnyHashable
    private var _set: (AnyHashable) -> Void
    
    var value: AnyHashable {
        get { _get() }
        nonmutating set { _set(newValue) }
    }
    
    private var _body: () -> AnyView
    var body: some View {
        // use copy not original
        _body()
    }
    // Take out name and entity, don't set here
    init<T: ShopItemAttribute>(_ attribute: T) {
        _get = { attribute.value }
        _set = { attribute.value = $0 as! T.Value }
        _body = { .init(attribute.body) }
        entity = attribute.entity
        name = attribute.name
    }
}

extension Library {
    struct Color: ShopItemAttribute {
        var entity: RealityKit.Entity?
        var name: String = ""
        var geoSubsetIndex: Int = 0
        
        private let parameterName = "Color"
        
        var value: SwiftUI.Color {
            get {
                guard
                    let material = entity?.shaderGraphMaterial(at: geoSubsetIndex),
                    material.hasMaterialParameter(named: parameterName)
                else { return .primary }
                
                guard case .color(let value) = material.getParameter(name: parameterName) else { return .primary }
                return SwiftUI.Color(cgColor: value)
            }
            
            nonmutating set {
                guard
                    let material = entity?.shaderGraphMaterial(at: geoSubsetIndex),
                    material.hasMaterialParameter(named: parameterName)
                else { return }
                
                entity?.update(shaderGraphMaterial: material, geoSubsetIndex: geoSubsetIndex) { mat in
                    try! mat.setParameter(name: parameterName, value: .color(UIColor(newValue)))
                }
            }
        }
        
        var body: some View {
            ColorPicker(name, selection: projectedValue)
        }
    }
}
