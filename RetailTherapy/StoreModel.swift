import Observation
import RealityKit

@Observable
class StoreModel {
    
    var rootEntity: Entity?
    var showImmersiveSpace = false
    var selectedItem: ShopItem.ID?
    
    var items: [ShopItem] = []
    
    //    var hashableItems: [AnyShopItem] {
    //        items.map { AnyShopItem($0) }
    //    }
    
    func item(id: ObjectIdentifier?) -> ShopItem? {
        items.first(where: { $0.id == id })
    }
}
