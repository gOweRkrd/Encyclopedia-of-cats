import Foundation

struct ImageResponse: Decodable {
    let url: URL?
}

struct NetworkModel: Decodable {
    let id: String
    let name: String
    let temperament: String
    let origin: String
    let description: String
    let wikipediaURL: URL?
    let energyLevel: Int
    let intelligence: Int
    let dogFriendly: Int
    let adaptability: Int
    let lifeSpan: String
    let affectionLevel: Int
    let referenceImageID: String?
    var imageURL: URL? 
    
    private enum CodingKeys: String, CodingKey {
        case id, name, temperament, origin, description
        case wikipediaURL = "wikipedia_url"
        case energyLevel = "energy_level"
        case adaptability
        case intelligence
        case dogFriendly = "dog_friendly"
        case lifeSpan = "life_span"
        case affectionLevel = "affection_level"
        case referenceImageID = "reference_image_id"
    }
}
