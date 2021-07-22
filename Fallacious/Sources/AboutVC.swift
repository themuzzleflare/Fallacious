import UIKit

final class AboutVC: UIViewController {
    // MARK: - Properties
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Life Cycle
    
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

// MARK: - Configuration

private extension AboutVC {
    private func configure() {
        title = "About"
        
        navigationController?.navigationBar.tintColor = UIColor(named: "AccentColor")
        navigationItem.title = "About"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AboutTopCell.self, forCellReuseIdentifier: AboutTopCell.reuseIdentifier)
        tableView.register(RightDetailCell.self, forCellReuseIdentifier: "attributeCell")
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - Actions

private extension AboutVC {
    @objc private func openSettings() {
        present(UINavigationController(rootViewController: SettingsVC()), animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AboutVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
            return 1
            case 1:
            return 2
            default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let aboutTopCell = tableView.dequeueReusableCell(withIdentifier: AboutTopCell.reuseIdentifier, for: indexPath) as? AboutTopCell else {
            fatalError("Unable to dequeue reusable cell with identifier: \(AboutTopCell.reuseIdentifier)")
        }
        
        guard let attributeCell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as? RightDetailCell else {
            fatalError("Unable to dequeue reusable cell with identifier: attributeCell")
        }
        
        attributeCell.selectionStyle = .none
        attributeCell.textLabel?.font = UIFont(name: "Museo900", size: UIFont.labelFontSize)
        attributeCell.detailTextLabel?.font = UIFont(name: "Museo300", size: UIFont.labelFontSize)
        
        switch section {
            case 0:
            return aboutTopCell
            case 1:
            switch row {
                case 0:
                attributeCell.textLabel?.text = "Version"
                attributeCell.detailTextLabel?.text = appDefaults.appVersion
                
                return attributeCell
                case 1:
                attributeCell.textLabel?.text = "Build"
                attributeCell.detailTextLabel?.text = appDefaults.appBuild
                
                return attributeCell
                default:
                fatalError("Unknown row")
            }
            default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
            case 1:
            return Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? "Copyright © 2021 Paul Tavitian"
            default:
            return nil
        }
    }
}

// MARK: - UITableViewDataSource

extension AboutVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 1:
            switch row {
                case 0:
                switch appDefaults.appVersion {
                    case "Unknown":
                    return nil
                    default:
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                        UIMenu(children: [
                            UIAction(title: "Copy Version", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                                UIPasteboard.general.string = appDefaults.appVersion
                            }
                        ])
                    }
                }
                case 1:
                switch appDefaults.appBuild {
                    case "Unknown":
                    return nil
                    default:
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                        UIMenu(children: [
                            UIAction(title: "Copy Build", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                                UIPasteboard.general.string = appDefaults.appBuild
                            }
                        ])
                    }
                }
                default:
                return nil
            }
            default:
            return nil
        }
    }
}
