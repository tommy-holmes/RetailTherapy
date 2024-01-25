import RealityKit

public enum ItemType: String, Codable {
    case bottle
    case notebook
    case mug
    case car
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
