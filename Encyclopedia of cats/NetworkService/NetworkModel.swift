import Foundation

struct NetworkModel: Decodable {
    let id: String
    let name: String
    let temperament: String
    let origin: String
    let description: String
    let wikipediaURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, temperament, origin, description
        case wikipediaURL = "wikipedia_url"
    }
}
