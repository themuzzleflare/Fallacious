import UIKit
import TinyConstraints

final class AboutTopCell: UITableViewCell {
    static let reuseIdentifier = "aboutTopCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

private extension AboutTopCell {
    private func configure() {
        selectionStyle = .none
        
        let appLogo = UIImageView(image: UIImage(named: "fallaciousLogo"))
        
        appLogo.width(100)
        appLogo.height(100)
        
        let nameLabel = UILabel()
        
        nameLabel.font = UIFont(name: "Museo900", size: 32)
        nameLabel.textAlignment = .center
        nameLabel.text = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Fallacious"
        
        let verticalStack = UIStackView(arrangedSubviews: [appLogo, nameLabel])
        
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fill
        verticalStack.spacing = 10
        
        contentView.addSubview(verticalStack)
        
        verticalStack.edges(to: contentView, insets: .horizontal(16) + .vertical(13))
    }
}
