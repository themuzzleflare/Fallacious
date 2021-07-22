import UIKit
import MarqueeLabel

final class FallacyDetailVC: UIViewController {
    private var fallacy: Fallacy
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    init(fallacy: Fallacy) {
        self.fallacy = fallacy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

private extension FallacyDetailVC {
    private func configure() {
        title = "Fallacy Details"
        
        let scrollingTitle = MarqueeLabel()
        
        scrollingTitle.translatesAutoresizingMaskIntoConstraints = false
        scrollingTitle.speed = .rate(65)
        scrollingTitle.fadeLength = 20
        scrollingTitle.textAlignment = .center
        scrollingTitle.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        scrollingTitle.text = fallacy.name
        
        navigationItem.title = fallacy.name
        navigationItem.titleView = scrollingTitle
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FallacyDetailTopCell.self, forCellReuseIdentifier: FallacyDetailTopCell.reuseIdentifier)
        tableView.register(RightDetailCell.self, forCellReuseIdentifier: "topAttributeCell")
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: "bottomAttributeCell")
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.showsVerticalScrollIndicator = false
    }
}

extension FallacyDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
            return 3
            case 1:
            return 3
            default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let fallacyDetailTopCell = tableView.dequeueReusableCell(withIdentifier: FallacyDetailTopCell.reuseIdentifier, for: indexPath) as? FallacyDetailTopCell else {
            fatalError("Unable to dequeue reusable cell with identifier: \(FallacyDetailTopCell.reuseIdentifier)")
        }
        
        guard let topAttributeCell = tableView.dequeueReusableCell(withIdentifier: "topAttributeCell", for: indexPath) as? RightDetailCell else {
            fatalError("Unable to dequeue reusable cell with identifier: topAttributeCell")
        }
        
        guard let bottomAttributeCell = tableView.dequeueReusableCell(withIdentifier: "bottomAttributeCell", for: indexPath) as? SubtitleCell else {
            fatalError("Unable to dequeue reusable cell with identifier: bottomAttributeCell")
        }
        
        fallacyDetailTopCell.fallacy = fallacy
        
        topAttributeCell.selectionStyle = .none
        topAttributeCell.textLabel?.font = UIFont(name: "Museo900", size: UIFont.labelFontSize)
        topAttributeCell.detailTextLabel?.font = UIFont(name: "Museo300", size: UIFont.labelFontSize)
        
        bottomAttributeCell.selectionStyle = .none
        bottomAttributeCell.textLabel?.font = UIFont(name: "Museo900", size: UIFont.labelFontSize)
        bottomAttributeCell.detailTextLabel?.font = UIFont(name: "Museo300", size: UIFont.smallSystemFontSize)
        bottomAttributeCell.detailTextLabel?.numberOfLines = 0
        
        switch section {
            case 0:
            switch row {
                case 0:
                return fallacyDetailTopCell
                case 1:
                topAttributeCell.textLabel?.text = "Name"
                topAttributeCell.detailTextLabel?.text = fallacy.name
                
                return topAttributeCell
                case 2:
                topAttributeCell.textLabel?.text = "Category"
                topAttributeCell.detailTextLabel?.text = fallacy.categoryName
                
                return topAttributeCell
                default:
                fatalError("Unknown row")
            }
            case 1:
            switch row {
                case 0:
                bottomAttributeCell.textLabel?.text = "Short Description"
                bottomAttributeCell.detailTextLabel?.text = fallacy.shortDescription
                
                return bottomAttributeCell
                case 1:
                bottomAttributeCell.textLabel?.text = "Long Description"
                bottomAttributeCell.detailTextLabel?.text = fallacy.longDescription
                
                return bottomAttributeCell
                case 2:
                bottomAttributeCell.textLabel?.text = fallacy.categoryName == "Cognitive Bias" ? "Solution" : "Example"
                bottomAttributeCell.detailTextLabel?.text = fallacy.example
                
                return bottomAttributeCell
                default:
                fatalError("Unknown row")
            }
            default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
            return "Overview"
            case 1:
            return "Details"
            default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
            case 0:
            return "Last Updated: \(fallacy.updateDate)"
            default:
            return nil
        }
    }
}

extension FallacyDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
            switch row {
                case 1:
                return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                    UIMenu(children: [
                        UIAction(title: "Copy Name", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                            UIPasteboard.general.string = self.fallacy.name
                        }
                    ])
                }
                case 2:
                return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                    UIMenu(children: [
                        UIAction(title: "Copy Category", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                            UIPasteboard.general.string = self.fallacy.categoryName
                        }
                    ])
                }
                default:
                return nil
            }
            case 1:
            switch row {
                case 0:
                return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                    UIMenu(children: [
                        UIAction(title: "Copy Short Description", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                            UIPasteboard.general.string = self.fallacy.shortDescription
                        }
                    ])
                }
                case 1:
                return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                    UIMenu(children: [
                        UIAction(title: "Copy Long Description", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                            UIPasteboard.general.string = self.fallacy.longDescription
                        }
                    ])
                }
                case 2:
                return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                    UIMenu(children: [
                        UIAction(title: "Copy \(self.fallacy.categoryName == "Cognitive Bias" ? "Solution" : "Example")", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                            UIPasteboard.general.string = self.fallacy.example
                        }
                    ])
                }
                default:
                return nil
            }
            default:
            return nil
        }
    }
}