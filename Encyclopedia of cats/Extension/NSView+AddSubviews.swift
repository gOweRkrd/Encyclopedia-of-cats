import Cocoa

extension NSView {

    func addSubviews(_ subviews: [NSView]) {
        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
