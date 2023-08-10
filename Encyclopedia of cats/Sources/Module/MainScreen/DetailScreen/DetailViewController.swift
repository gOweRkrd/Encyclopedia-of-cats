import Cocoa

final class DetailViewController: NSViewController {
    
    private var breed: NetworkModel?
    
    // MARK: - Ui
    
    private let catImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }()
    
    private lazy var viewPhotosButton: NSButton = {
        let button = NSButton(title: "View Photos", target: self, action: #selector(viewPhotosButtonTapped))
        button.bezelStyle = .rounded
        return button
    }()
    
    private let descriptionTextView: NSTextView = {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        return textView
    }()
    
    private let nameBreadLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 26.0)
        return label
    }()
    
    private let temperamentLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let adaptabilityLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let originLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let lifeSpan: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let descriptionLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let wikipediaLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let energyLevelLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let intelligenceLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let affectionLevelLabel: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private let dogFriendly: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = descriptionTextView
        addSubviewsView()
        setupConstraints()
        showViewPhotosButton(false)
    }
    
    // MARK: - Private methods
    
    func updateData(with breed: NetworkModel) {
        self.breed = breed
        energyLevelLabel.stringValue = "Energy Level: " + starRating(for: breed.energyLevel)
        intelligenceLabel.stringValue = "Intelligence: " + starRating(for: breed.intelligence)
        dogFriendly.stringValue = "Dog Friendly: " + starRating(for: breed.dogFriendly)
        temperamentLabel.stringValue = "Temperament: \(breed.temperament)"
        originLabel.stringValue = "Origin: \(breed.origin)"
        descriptionLabel.stringValue = "Description: \(breed.description)"
        nameBreadLabel.stringValue = "Name of the breed: \(breed.name)"
        lifeSpan.stringValue = "Life span: \(breed.lifeSpan)"
        adaptabilityLabel.stringValue = "Adaptability: " + starRating(for: breed.adaptability)
        affectionLevelLabel.stringValue = "Affection level: " + starRating(for: breed.affectionLevel)
        
        showViewPhotosButton(true)
        setLinkWikipedia()
        fetchImage()
    }
    
    // MARK: - Private methods
    
    private func fetchImage() {
        if let imageURL = breed?.imageURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL),
                   let image = NSImage(data: data) {
                    DispatchQueue.main.async {
                        self.catImageView.image = image
                    }
                }
            }
        } else {
            catImageView.image = nil
        }
    }
    
    private func setLinkWikipedia() {
        if let wikipediaURL = breed?.wikipediaURL {
            let wikipediaLink = "Link of Wikipedia: \(wikipediaURL.absoluteString)"
            let attributedString = NSMutableAttributedString(string: wikipediaLink)
            let linkRange = (wikipediaLink as NSString).range(of: wikipediaURL.absoluteString)
            
            if linkRange.location != NSNotFound {
                attributedString.addAttribute(.link, value: wikipediaURL.absoluteString, range: linkRange)
            }
            
            wikipediaLabel.isSelectable = true
            wikipediaLabel.allowsEditingTextAttributes = true
            wikipediaLabel.attributedStringValue = attributedString
        } else {
            wikipediaLabel.stringValue = "Link of Wikipedia: Not available"
            wikipediaLabel.isSelectable = false
            wikipediaLabel.allowsEditingTextAttributes = false
        }
    }
    
    private func starRating(for value: Int) -> String {
        let filledStar = "★"
        let emptyStar = "☆"
        let maxRating = 5
        let filledStarsCount = min(maxRating, max(0, value))
        
        let filledStars = String(repeating: filledStar, count: filledStarsCount)
        let emptyStars = String(repeating: emptyStar, count: maxRating - filledStarsCount)
        
        return filledStars + emptyStars
    }
    
    private func showViewPhotosButton(_ show: Bool) {
        viewPhotosButton.isHidden = !show
    }
    
    @objc
    private func viewPhotosButtonTapped() {
        let photoCollectionViewController = PhotoCollectionViewController()
        photoCollectionViewController.selectedBreed = breed
        
        let window = NSWindow(contentViewController: photoCollectionViewController)
        window.styleMask = [.closable, .titled]
        window.title = "Photos"
        window.setContentSize(NSSize(width: 500, height: 500))
        window.center()
        
        window.makeKeyAndOrderFront(nil)
    }
}

// MARK: - Setup constrains

private extension DetailViewController {
    
    func addSubviewsView() {
        view.addSubview(energyLevelLabel)
        view.addSubview(intelligenceLabel)
        view.addSubview(dogFriendly)
        view.addSubview(temperamentLabel)
        view.addSubview(originLabel)
        view.addSubview(wikipediaLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nameBreadLabel)
        view.addSubview(lifeSpan)
        view.addSubview(adaptabilityLabel)
        view.addSubview(affectionLevelLabel)
        view.addSubview(catImageView)
        view.addSubview(viewPhotosButton)
        
        energyLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        intelligenceLabel.translatesAutoresizingMaskIntoConstraints = false
        dogFriendly.translatesAutoresizingMaskIntoConstraints = false
        temperamentLabel.translatesAutoresizingMaskIntoConstraints = false
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        wikipediaLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameBreadLabel.translatesAutoresizingMaskIntoConstraints = false
        lifeSpan.translatesAutoresizingMaskIntoConstraints = false
        adaptabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        affectionLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        viewPhotosButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameBreadLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: .topAnchor),
            nameBreadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            catImageView.topAnchor.constraint(equalTo: nameBreadLabel.bottomAnchor, constant: .leadingAnchor),
            catImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            catImageView.widthAnchor.constraint(equalToConstant: .sizeImage),
            catImageView.heightAnchor.constraint(equalToConstant: .sizeImage),
            
            viewPhotosButton.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: 30),
            viewPhotosButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            originLabel.topAnchor.constraint(equalTo: viewPhotosButton.bottomAnchor, constant: 30),
            originLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            lifeSpan.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: .topAnchor),
            lifeSpan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            temperamentLabel.topAnchor.constraint(equalTo: lifeSpan.bottomAnchor, constant: .topAnchor),
            temperamentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperamentLabel.bottomAnchor, constant: .topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            wikipediaLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .topAnchor),
            wikipediaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            energyLevelLabel.topAnchor.constraint(equalTo: wikipediaLabel.bottomAnchor, constant: 20),
            energyLevelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            intelligenceLabel.topAnchor.constraint(equalTo: energyLevelLabel.bottomAnchor, constant: .leadingAnchor),
            intelligenceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            adaptabilityLabel.topAnchor.constraint(equalTo: intelligenceLabel.bottomAnchor, constant: .leadingAnchor),
            adaptabilityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            affectionLevelLabel.topAnchor.constraint(equalTo: adaptabilityLabel.bottomAnchor, constant: .leadingAnchor),
            affectionLevelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor),
            
            dogFriendly.topAnchor.constraint(equalTo: affectionLevelLabel.bottomAnchor, constant: .leadingAnchor),
            dogFriendly.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leadingAnchor)
        ])
    }
}

// MARK: - Constant Constraints

private extension CGFloat {
    static let leadingAnchor: CGFloat = 10
    static let topAnchor: CGFloat = 15
    static let sizeImage: CGFloat = 250
}
