import Observation
import RealityKit

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
