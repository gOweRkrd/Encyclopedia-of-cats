import Foundation

final class NetworkManager { 
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCatBreeds(completion: @escaping ([NetworkModel]?) -> Void) {
        let apiKey = "live_yqJTWHB0Cu3gnYox6LBsIXGa6z0g2AKW6Bst5fuUm3JGrWUrlTHefPjdyDmP3LqV"
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching cat breeds: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let catBreeds = try JSONDecoder().decode([NetworkModel].self, from: data)
                completion(catBreeds)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
        
    }
}
