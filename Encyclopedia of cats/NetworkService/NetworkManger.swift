import Foundation

final class NetworkManager { 
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCatBreeds(completion: @escaping ([String]) -> Void) {
        let catBreeds = ["Maine Coon", "Siamese", "Persian", "Bengal", "Sphynx", "Ragdoll, Maine Coon", "Siamese", "Persian", "Bengal", "Sphynx", "Ragdoll, Maine Coon", "Siamese", "Persian", "Bengal", "Sphynx", "Ragdoll"]
        completion(catBreeds)
    }
}
