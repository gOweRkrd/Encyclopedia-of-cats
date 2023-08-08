import Cocoa

final class ViewController: NSViewController {
    
    var catBreeds: [NetworkModel] = []
    let breedDescriptionViewController = DetailViewController()
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("catBreedColumn"))
        tableView.addTableColumn(column)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        addSubviewsView()
        setupConstraints()
        tableView.reloadData()
        fetchCatBreeds()
        
    }
    
    func fetchCatBreeds() {
        NetworkManager.shared.fetchCatBreeds { [weak self] breeds in
            if let breeds = breeds {
                self?.catBreeds = breeds
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - NSTableViewDataSource

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return catBreeds.count
    }
}

// MARK: - NSTableViewDelegate

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier("catBreedCellIdentifier")
        
        if let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? MainCellView {
            cell.configure(with: catBreeds[row])
            return cell
        }
        
        let cell = MainCellView(frame: NSRect(x: 0, y: 0, width: tableColumn?.width ?? 100, height: tableView.rowHeight))
        cell.identifier = cellIdentifier
        cell.configure(with: catBreeds[row])
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        if selectedRow >= 0 && selectedRow < catBreeds.count {
            let selectedBreed = catBreeds[selectedRow]
            
            breedDescriptionViewController.updateData(with: selectedBreed)
        }
    }
    
}

// MARK: - Setup constrains

private extension ViewController {
    
    func addSubviewsView() {
        addChild(breedDescriptionViewController)
        view.addSubview(breedDescriptionViewController.view)
        view.addSubview(tableView)
        breedDescriptionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            breedDescriptionViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            breedDescriptionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            breedDescriptionViewController.view.leadingAnchor.constraint(equalTo: tableView.trailingAnchor),
            breedDescriptionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
