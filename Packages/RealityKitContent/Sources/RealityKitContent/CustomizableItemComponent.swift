import RealityKit

public enum ItemType: String, Codable {
    case bottle
    case whiskey
}

// Ensure you register this component in your app’s delegate using:
// CustomizableItemComponent.registerComponent()
public struct CustomizableItemComponent: Component, Codable {
    var itemType: ItemType = .bottle
    public var name: String = ""

    public init() { }
}

public extension CustomizableItemComponent {
    var assetName: String {
        itemType.rawValue.capitalized
    }
}
