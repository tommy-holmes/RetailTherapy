import Observation
import RealityKit

@Observable
class StoreModel {
    
    var rootEntity: Entity?
    var showingImmersiveSpace = false
    var selectedItem: ShopItem.ID?
    
    var items: [ShopItem] = []
    
    func item(id: ObjectIdentifier?) -> ShopItem? {
        items.first(where: { $0.id == id })
    }
}
