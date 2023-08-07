import Cocoa

class DetailViewController: NSViewController {
    
    private let descriptionTextView: NSTextView = {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    override func loadView() {
        self.view = descriptionTextView
    }
    
    func updateDescription(with description: String) {
        descriptionTextView.string = description
    }
}
