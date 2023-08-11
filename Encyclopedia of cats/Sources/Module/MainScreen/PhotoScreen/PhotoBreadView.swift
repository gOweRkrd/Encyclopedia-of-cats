import Cocoa

final class PhotoBreadView: NSView {
    
    // MARK: - Ui
    
    let collectionView: NSCollectionView = {
        let collectionView = NSCollectionView()
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10 
        flowLayout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = flowLayout
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsView()
        setupConstraints()
        collectionView.register(PhotoCellView.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("PhotoCell"))
        layer?.backgroundColor = R.Colors.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setup Constrains

private extension PhotoBreadView {
    
    func addSubviewsView() {
        self.addSubviews([collectionView])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

}
