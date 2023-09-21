import RealityKit

public enum ItemType: String, Codable {
    case bottle
    case whiskey
    case notebook
    case mug
}

// Ensure you register this component in your app’s delegate using:
// CustomizableItemComponent.registerComponent()
public struct CustomizableItemComponent: Component, Codable {
    public var itemType: ItemType = .bottle

    public init() { }
}

public extension CustomizableItemComponent {
    var assetName: String {
        itemType.rawValue.capitalized
    }
}
