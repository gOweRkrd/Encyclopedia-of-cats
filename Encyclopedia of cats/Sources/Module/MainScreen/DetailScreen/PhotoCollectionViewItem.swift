import Cocoa

class PhotoCollectionViewItem: NSCollectionViewItem {
    
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
    
    override func loadView() {
        view = NSView()
        view.addSubview(customImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
              customImageView.topAnchor.constraint(equalTo: view.topAnchor),
              customImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              customImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              customImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              customImageView.widthAnchor.constraint(equalToConstant: 200),  // You can remove this line
              customImageView.heightAnchor.constraint(equalToConstant: 200)  // You can remove this line
          ])
    }
}
