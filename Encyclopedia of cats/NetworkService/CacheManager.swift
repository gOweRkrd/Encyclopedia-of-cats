import Foundation

final class CacheManager {
    
    static let shared = CacheManager()
    private init() {}
    
    private var cache: [String: Any] = [:]
    
    func storeObject(_ object: Any, forKey key: String) {
        cache[key] = object
    }
    
    func getObject(forKey key: String) -> Any? {
        return cache[key]
    }
}
