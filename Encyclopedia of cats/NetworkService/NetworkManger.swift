import Foundation

enum NetworkError: Error {
    case requestFailed
    case invalidResponse
    case decodingFailed
    case imageNotFound
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCatBreeds(completion: @escaping ([NetworkModel]?, Error?) -> Void) {
        
        if let cachedBreeds = CacheManager.shared.getObject(forKey: "catBreeds") as? [NetworkModel] {
            completion(cachedBreeds, nil)
            return
        }
        
        let apiKey = "live_yqJTWHB0Cu3gnYox6LBsIXGa6z0g2AKW6Bst5fuUm3JGrWUrlTHefPjdyDmP3LqV"
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching cat breeds: \(error)")
                completion(nil, NetworkError.requestFailed)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil, NetworkError.invalidResponse)
                return
            }
            
            do {
                var catBreeds = try JSONDecoder().decode([NetworkModel].self, from: data)
                
                let imageFetchGroup = DispatchGroup()
                for index in catBreeds.indices {
                    if let referenceImageID = catBreeds[index].referenceImageID {
                        imageFetchGroup.enter()
                        self.fetchBreedImageURL(referenceImageID: referenceImageID) { imageURL, _ in
                            if let imageURL = imageURL {
                                catBreeds[index].imageURL = imageURL
                            }
                            imageFetchGroup.leave()
                        }
                    }
                }
                imageFetchGroup.notify(queue: .main) {
                    CacheManager.shared.storeObject(catBreeds, forKey: "catBreeds")
                    completion(catBreeds, nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil, NetworkError.decodingFailed)
            }
        }.resume()
        
    }
    
    func fetchBreedImageURL(referenceImageID: String, completion: @escaping (URL?, Error?) -> Void) {
        let apiKey = "live_yqJTWHB0Cu3gnYox6LBsIXGa6z0g2AKW6Bst5fuUm3JGrWUrlTHefPjdyDmP3LqV"
        let url = URL(string: "https://api.thecatapi.com/v1/images/\(referenceImageID)")!
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching breed image URL: \(error)")
                completion(nil, NetworkError.requestFailed)
                return
            }
            
            guard let data = data else {
                print("No data received for breed image URL")
                completion(nil, NetworkError.invalidResponse)
                return
            }
            
            do {
                let imageResponse = try JSONDecoder().decode(ImageResponse.self, from: data)
                if let url = imageResponse.url {
                    completion(url, nil)
                } else {
                    completion(nil, NetworkError.imageNotFound)
                }
            } catch {
                print("Error decoding image URL JSON: \(error)")
                completion(nil, NetworkError.decodingFailed)
            }
        }.resume()
    }
    
    func fetchBreedImages(breedID: String, page: Int, limit: Int, completion: @escaping ([URL], Error?) -> Void) {
        let apiKey = "live_yqJTWHB0Cu3gnYox6LBsIXGa6z0g2AKW6Bst5fuUm3JGrWUrlTHefPjdyDmP3LqV"
        let urlString = "https://api.thecatapi.com/v1/images/search?breed_ids=\(breedID)&page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([], NetworkError.invalidResponse)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching breed images: \(error)")
                completion([], NetworkError.requestFailed)
                return
            }
            
            guard let data = data else {
                print("No data received for breed images")
                completion([], NetworkError.invalidResponse)
                return
            }
            
            do {
                let imageResponses = try JSONDecoder().decode([ImageResponse].self, from: data)
                let imageUrls = imageResponses.compactMap { $0.url }
                completion(imageUrls, nil)
            } catch {
                print("Error decoding breed images JSON: \(error)")
                completion([], NetworkError.decodingFailed)
            }
        }.resume()
    }
}
