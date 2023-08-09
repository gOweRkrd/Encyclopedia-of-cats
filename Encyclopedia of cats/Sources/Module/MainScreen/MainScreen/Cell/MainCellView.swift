import Cocoa

final class MainCellView: NSTableCellView {
    
    private let containerView: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let breadLabel: NSTextField = {
        let label = NSTextField()
        label.isBordered = false
        label.isEditable = false
        label.backgroundColor = NSColor.clear
        label.autoresizingMask = [.width, .height]
        label.backgroundColor = NSColor.clear
        label.font = NSFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubviewsView()
        setupConstraints()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    // MARK: - Public methods
    
    func configure(with breed: NetworkModel) {
        breadLabel.stringValue = breed.name
    }
}

// MARK: - Setup constraints

private extension MainCellView {
    
    func addSubviewsView() {
        addSubview(containerView)
        containerView.addSubview(breadLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            breadLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            breadLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
    }
}
