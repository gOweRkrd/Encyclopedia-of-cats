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
                var catBreeds = try JSONDecoder().decode([NetworkModel].self, from: data)
                
                let imageFetchGroup = DispatchGroup()
                for index in catBreeds.indices {
                    if let referenceImageID = catBreeds[index].referenceImageID {
                        imageFetchGroup.enter()
                        self.fetchBreedImageURL(referenceImageID: referenceImageID) { imageURL in
                            catBreeds[index].imageURL = imageURL
                            imageFetchGroup.leave()
                        }
                    }
                }
                imageFetchGroup.notify(queue: .main) {
                    completion(catBreeds)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
        
    }
    
    func fetchBreedImageURL(referenceImageID: String, completion: @escaping (URL?) -> Void) {
        let apiKey = "live_yqJTWHB0Cu3gnYox6LBsIXGa6z0g2AKW6Bst5fuUm3JGrWUrlTHefPjdyDmP3LqV"
        let url = URL(string: "https://api.thecatapi.com/v1/images/\(referenceImageID)")!
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching breed image URL: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received for breed image URL")
                completion(nil)
                return
            }
            
            do {
                let imageResponse = try JSONDecoder().decode(ImageResponse.self, from: data)
                if let url = imageResponse.url {
                    completion(url)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding image URL JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
