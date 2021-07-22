import UIKit

final class SettingsVC: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
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

private extension SettingsVC {
    private func configure() {
        title = "Settings"
        
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSettings))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnimationsCell.self, forCellReuseIdentifier: AnimationsCell.reuseIdentifier)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc private func closeSettings() {
        navigationController?.dismiss(animated: true)
    }
}

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimationsCell.reuseIdentifier, for: indexPath) as? AnimationsCell else {
            fatalError("Unable to dequeue reusable cell with identifier: \(AnimationsCell.reuseIdentifier)")
        }
        
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
