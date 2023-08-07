import Cocoa

final class DetailViewController: NSViewController {
    private let descriptionTextView: NSTextView = {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    private var breed: NetworkModel? 
    
    override func loadView() {
        self.view = descriptionTextView
    }
    
    func updateDescription(with description: String) {
        descriptionTextView.string = description
    }
    
    func updateData(with breed: NetworkModel) {
        self.breed = breed
    }
}
