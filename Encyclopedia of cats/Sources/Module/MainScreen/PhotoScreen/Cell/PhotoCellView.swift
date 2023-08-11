import Cocoa

final class PhotoCellView: NSCollectionViewItem {
    
    static let identifier = NSUserInterfaceItemIdentifier("PhotoCollectionViewItemIdentifier")
    
    lazy var customImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var representedObject: Any? {
        didSet {
            if let image = representedObject as? NSImage {
                customImageView.image = image
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = NSView()
        view.addSubview(customImageView)
        view.wantsLayer = true
        view.layer?.backgroundColor = R.Colors.lightGray.cgColor
        setupConstraints()
    }
}

// MARK: - Setup constraints

private extension PhotoCellView {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: view.topAnchor),
            customImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: .sizeImage),
            customImageView.heightAnchor.constraint(equalToConstant: .sizeImage)
        ])
    }
}

// MARK: - Constant Constraints

private extension CGFloat {
    static let sizeImage: CGFloat = 250
}
