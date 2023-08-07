import Cocoa

final class MainCellView: NSTableCellView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupUI()
    }
    
    func setupUI() {
        let label = NSTextField(frame: bounds)
        label.isBordered = false
        label.isEditable = false
        label.backgroundColor = NSColor.clear
        label.autoresizingMask = [.width, .height]
        addSubview(label)
    }
    
    func configure(with breed: NetworkModel) {
        if let label = subviews.first as? NSTextField {
            label.stringValue = breed.name
        }
    }
}
