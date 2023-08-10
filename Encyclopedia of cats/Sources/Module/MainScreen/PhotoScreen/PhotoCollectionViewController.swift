import Cocoa

final class PhotoCollectionViewController: NSViewController {
    
    var selectedBreed: NetworkModel?
    private var photos: [NSImage] = []
    private var currentPage = 1
    private let imagesPerPage = 10
    
    // MARK: - Ui
    
    private let collectionView: NSCollectionView = {
        let collectionView = NSCollectionView()
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = flowLayout
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = collectionView
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("PhotoCell"))
    }
    
    // MARK: - Private methods
    
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
                                    print("Image size: \(image.size)")
                                    loadedImages.append(image)
                                    
                                }
                            }.resume()
                        }
                    }
                    
                    group.wait()
                    
                    DispatchQueue.main.async {
                        self?.photos += loadedImages
                        self?.collectionView.reloadData()
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
        if let photoItem = item as? PhotoCollectionViewItem {
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

// MARK: - Setup constrains

private extension PhotoCollectionViewController {
    
    func addSubviewsView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
