import UIKit
import CloudKit

final class FallaciousVC: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.delegate = self
        sc.searchBar.searchBarStyle = .minimal
        return sc
    }()
    
    private let tableRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshFallacies), for: .valueChanged)
        return rc
    }()
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Fallacy>
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Fallacy>
    
    private enum Section {
        case main
    }
    
    private enum FilterCategory: String, CaseIterable {
        case all = "All"
        case fallacies = "Logical Fallacies"
        case biases = "Cognitive Biases"
    }
    
    private lazy var dataSource = makeDataSource()
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, fallacy in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FallacyCell.reuseIdentifier, for: indexPath) as? FallacyCell else {
                    fatalError("Unable to dequeue reusable cell with identifier: \(FallacyCell.reuseIdentifier)")
                }
                
                cell.fallacy = fallacy
                
                return cell
            }
        )
        
        dataSource.defaultRowAnimation = .fade
        
        return dataSource
    }
    
    private func applySnapshot(animate: Bool = false) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(filteredFallacies, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private var filter: FilterCategory = .all {
        didSet {
            navigationItem.rightBarButtonItem?.menu = filterMenu()
            applySnapshot(animate: true)
        }
    }
    
    private var showFeaturedOnly: Bool = false {
        didSet {
            navigationItem.rightBarButtonItem?.menu = filterMenu()
            applySnapshot(animate: true)
        }
    }
    
    private var fallacies: [Fallacy] = []
    
    private var filteredFallacies: [Fallacy] {
        fallacies.filter { fallacy in
            (!showFeaturedOnly || fallacy.featured)
            && (filter == .all || filter.rawValue == fallacy.categoryNamePlural)
            && (searchController.searchBar.text!.isEmpty || fallacy.name.localizedStandardContains(searchController.searchBar.text!))}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configure()
        applySnapshot()
        fetchFallacies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

private extension FallaciousVC {
    private func configure() {
        title = "Fallacious"
        definesPresentationContext = true
        
        navigationController?.navigationBar.tintColor = UIColor(named: "AccentColor")
        navigationItem.title = "Fallacious"
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", image: UIImage(systemName: "slider.horizontal.3"), primaryAction: nil, menu: filterMenu())
        navigationItem.searchController = searchController
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(FallacyCell.self, forCellReuseIdentifier: FallacyCell.reuseIdentifier)
        tableView.refreshControl = tableRefreshControl
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @objc private func refreshFallacies() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchFallacies()
        }
    }
    
    private func filterMenu() -> UIMenu {
        return UIMenu(image: UIImage(systemName: "slider.horizontal.3"), children: [
            UIMenu(title: "Category", options: .displayInline, children: FilterCategory.allCases.map { category in
                UIAction(title: category.rawValue, state: filter == category ? .on : .off) { _ in
                    self.filter = category
                }
            }),
            UIAction(title: "Featured Only", image: UIImage(systemName: "star.fill"), state: showFeaturedOnly ? .on : .off) { _ in
                self.showFeaturedOnly.toggle()
            }
        ])
    }
    
    private func fetchFallacies() {
        let db = CKContainer.default().publicCloudDatabase
        
        let query = CKQuery(recordType: "itemData", predicate: NSPredicate(value: true))
        
        query.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true),
            NSSortDescriptor(key: "number", ascending: true)
        ]
        
        let operation = CKQueryOperation(query: query)
        
        operation.zoneID = .default
        operation.desiredKeys = ["id", "number", "name", "categoryName", "categoryNamePlural", "shortDescription", "longDescription", "example", "symbol", "isFeatured"]
        operation.resultsLimit = 200
        
        var newFallacies = [Fallacy]()
        
        operation.recordFetchedBlock = { record in
            var fallacy = Fallacy()
            
            fallacy.recordID = record.recordID
            fallacy.lastUpdated = record.modificationDate
            fallacy.customId = record["id"] as! Int64
            fallacy.number = record["number"] as! Int64
            fallacy.name = record["name"] as! String
            fallacy.categoryName = record["categoryName"] as! String
            fallacy.categoryNamePlural = record["categoryNamePlural"] as! String
            fallacy.shortDescription = record["shortDescription"] as! String
            fallacy.longDescription = record["longDescription"] as! String
            fallacy.example = record["example"] as! String
            fallacy.symbol = record["symbol"] as! String
            fallacy.isFeatured = record["isFeatured"] as! Int64
            
            newFallacies.append(fallacy)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.fallacies = []
                    self.applySnapshot()
                    self.tableView.refreshControl?.endRefreshing()
                    
                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
                    
                    ac.addAction(dismissAction)
                    
                    self.present(ac, animated: true)
                } else {
                    self.fallacies = newFallacies
                    self.applySnapshot()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
        
        db.add(operation)
    }
}

extension FallaciousVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let fallacy = dataSource.itemIdentifier(for: indexPath) {
            navigationController?.pushViewController(FallacyDetailVC(fallacy: fallacy), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let fallacy = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(children: [
                UIAction(title: "Copy Name", image: UIImage(systemName: "textformat")) { _ in
                    UIPasteboard.general.string = fallacy.name
                },
                UIAction(title: "Copy Description", image: UIImage(systemName: "text.alignright")) { _ in
                    UIPasteboard.general.string = fallacy.shortDescription
                }
            ])
        }
    }
}

extension FallaciousVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySnapshot(animate: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.text = ""
            applySnapshot(animate: true)
        }
    }
}
