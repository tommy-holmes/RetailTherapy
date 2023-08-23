import Observation
import RealityKit
import RealityKitContent

@Observable
class StoreModel {
    
    var rootEntity: Entity? = nil
    var showImmersiveSpace = false
    
    var items: [CustomizableItemRuntimeComponent] = []
}
