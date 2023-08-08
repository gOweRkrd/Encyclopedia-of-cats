import Cocoa

final class DetailViewController: NSViewController {
    private let descriptionTextView: NSTextView = {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true  
        return textView
    }()
    
    private var breed: NetworkModel?
    
    override func loadView() {
        self.view = descriptionTextView
    }
    
    func updateDescription(with description: String, wikipediaURL: URL?) {
        var attributedDescription = NSMutableAttributedString(string: description)
        
        if let wikipediaURL = wikipediaURL {
            let linkRange = (description as NSString).range(of: "Link of Wikipedia:")
            attributedDescription.addAttribute(.link, value: wikipediaURL.absoluteString, range: linkRange)
        }
        
        let fontSize: CGFloat = 16.0
        let font = NSFont.systemFont(ofSize: fontSize)
        attributedDescription.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedDescription.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 10.0
        attributedDescription.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedDescription.length))
        
        descriptionTextView.textStorage?.setAttributedString(attributedDescription)
    }
    
    func updateData(with breed: NetworkModel) {
        self.breed = breed
    }
}
