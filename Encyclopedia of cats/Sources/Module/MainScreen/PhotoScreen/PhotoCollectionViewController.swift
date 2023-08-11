import Cocoa

final class PhotoCollectionViewController: NSViewController {
    
    var selectedBreed: NetworkModel?
    private var photos: [NSImage] = []
    private var currentPage = 1
    private let photoBreadView = PhotoBreadView()
    private let imagesPerPage = 10
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = photoBreadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        delegateCollectionView()
        self.photoBreadView.collectionView.collectionViewLayout?.invalidateLayout()
    }
    
    // MARK: - Private methods
    
    private func delegateCollectionView() {
        photoBreadView.collectionView.dataSource = self
        photoBreadView.collectionView.delegate = self
    }
    private func fetchImage() {
        if let selectedBreed = selectedBreed {
            NetworkManager.shared.fetchBreedImages(breedID: selectedBreed.id, page: currentPage, limit: imagesPerPage) { [weak self] imageUrls in
                DispatchQueue.global(qos: .userInitiated).async {
                    var loadedImages: [NSImage] = []
                    
                    let group = DispatchGroup()
                    
                    for imageUrl in imageUrls {
                        group.enter()
                        if let url = URL(string: imageUrl.absoluteString) {
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                defer { group.leave() }
                                if let data = data, let image = NSImage(data: data) {
                                    loadedImages.append(image)
                                    
                                }
                            }.resume()
                        }
                    }
                    
                    group.wait()
                    
                    DispatchQueue.main.async {
                        self?.photos += loadedImages
                        self?.photoBreadView.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - NSCollectionViewDataSource

extension PhotoCollectionViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("PhotoCell"), for: indexPath)
        if let photoItem = item as? PhotoCellView {
            photoItem.representedObject = photos[indexPath.item]
        }
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        if indexPath.item == photos.count - 1 {
            currentPage += 1
            fetchImage()
        }
    }
    
}

// MARK: - NSCollectionViewDelegate

extension PhotoCollectionViewController: NSCollectionViewDelegate {}

// MARK: - CollectionViewDelegateFlowLayout

extension PhotoCollectionViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 250
        let cellHeight: CGFloat = 250
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
