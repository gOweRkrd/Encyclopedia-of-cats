import Cocoa

enum StringResources {
    
    enum DetailViewController {
        static let energyLevelLabel = "Energy Level: "
        static let intelligenceLabel = "Intelligence: "
        static let dogFriendly = "Dog Friendly: "
        static let temperamentLabel = "Temperament: "
        static let originLabel = "Origin:"
        static let descriptionLabel = "Description: "
        static let nameBreadLabel = "Name of the breed: "
        static let lifeSpan = "Adaptability: "
        static let adaptabilityLabel = "Adaptability: "
        static let affectionLevelLabel = "Affection level: "
        static let viewPhotosButton = "View photos"
        static let title = "Photos this bread"
        static let wikipediaLink = "Link of Wikipedia:"
        static let wikipediaLinkError = "Link of Wikipedia: Not available"
    }
    
    enum Colors {
        static let white = NSColor(hexString: "#FFFFFF")
        static let black = NSColor(hexString: "#000000")
        static let beige = NSColor(hexString: "#f5f5dc")
        static let lightGray = NSColor(hexString: "#F1EBE7")
    }
}

typealias R = StringResources
