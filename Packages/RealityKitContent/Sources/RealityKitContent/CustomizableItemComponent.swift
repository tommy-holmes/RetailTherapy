import RealityKit

public enum ShopItem: String, Codable {
    case bottle
}

// Ensure you register this component in your app’s delegate using:
// CustomizableItemComponent.registerComponent()
public struct CustomizableItemComponent: Component, Codable {
    var itemType: ShopItem = .bottle

    public init() { }
}

public extension CustomizableItemComponent {
    var assetName: String {
        itemType.rawValue.capitalized
    }
}
