import SwiftUI

struct ShopScheme {
    let name: String
    let logo: String
    let brandColor: Color
}

extension ShopScheme: Identifiable {
    var id: String { name }
}

extension ShopScheme: Equatable { }

extension ShopScheme {
    static var moo = ShopScheme(name: "MOO", logo: "MOO", brandColor: Color(red: 43, green: 111, blue: 82))
    static var tesco = ShopScheme(name: "Tesco", logo: "Tesco", brandColor: Color(red: 43, green: 111, blue: 82))
    static var amazon = ShopScheme(name: "Amazon", logo: "Amazon", brandColor: Color(red: 43, green: 111, blue: 82))
    static var louisVitton = ShopScheme(name: "Louis Vitton", logo: "LV", brandColor: Color(red: 43, green: 111, blue: 82))
}

extension ShopScheme {
    static let mocks: [Self] = [.moo, .tesco, .amazon, .louisVitton,]
}
