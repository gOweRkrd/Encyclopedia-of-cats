import Cocoa

final class DetailViewController: NSViewController {
    
    private var breed: NetworkModel?
    
    // MARK: - Ui
    
    private let catImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
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
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nameBreadLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            nameBreadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            catImageView.topAnchor.constraint(equalTo: nameBreadLabel.bottomAnchor, constant: 10),
            catImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            catImageView.widthAnchor.constraint(equalToConstant: 250),
            catImageView.heightAnchor.constraint(equalToConstant: 250),
            
            originLabel.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: 30),
            originLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            lifeSpan.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 15),
            lifeSpan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            temperamentLabel.topAnchor.constraint(equalTo: lifeSpan.bottomAnchor, constant: 15),
            temperamentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperamentLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            wikipediaLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            wikipediaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            energyLevelLabel.topAnchor.constraint(equalTo: wikipediaLabel.bottomAnchor, constant: 20),
            energyLevelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            intelligenceLabel.topAnchor.constraint(equalTo: energyLevelLabel.bottomAnchor, constant: 10),
            intelligenceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            adaptabilityLabel.topAnchor.constraint(equalTo: intelligenceLabel.bottomAnchor, constant: 10),
            adaptabilityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            affectionLevelLabel.topAnchor.constraint(equalTo: adaptabilityLabel.bottomAnchor, constant: 10),
            affectionLevelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            dogFriendly.topAnchor.constraint(equalTo: affectionLevelLabel.bottomAnchor, constant: 10),
            dogFriendly.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }
}
