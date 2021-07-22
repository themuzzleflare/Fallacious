import UIKit
import Macaw
import TinyConstraints

final class FallacyCell: UITableViewCell {
    static let reuseIdentifier = "fallacyCell"
    
    var fallacy: Fallacy! {
        didSet {
            fallacySymbol.font = fallacy.categoryName == "Cognitive Bias" ? UIFont(name: "ybi", size: 37.5) : UIFont(name: "YLF", size: 27.5)
            fallacySymbol.text = fallacy.symbol
            fallacyName.text = fallacy.name.lowercased()
            fallacyDescription.text = fallacy.shortDescription
            featuredStar.isHidden = !fallacy.featured
        }
    }
    
    private let fallacySymbol = UILabel()
    
    private let fallacyName = UILabel()
    
    private let fallacyDescription = UILabel()
    
    private let featuredStar = UIImageView(image: UIImage(systemName: "star.fill"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

private extension FallacyCell {
    private func configure() {
        accessoryType = .disclosureIndicator
        
        let symbolContainerView = UIView()
        
        let squareButton = SVGView()
        
        squareButton.backgroundColor = .clear
        squareButton.fileName = "square-button"
        squareButton.width(50)
        squareButton.height(50)
        
        symbolContainerView.addSubview(squareButton)
        symbolContainerView.addSubview(fallacySymbol)
        symbolContainerView.width(50)
        symbolContainerView.height(50)
        
        let verticalStack = UIStackView(arrangedSubviews: [fallacyName, fallacyDescription])
        let horizontalStack = UIStackView(arrangedSubviews: [symbolContainerView, verticalStack, featuredStar])
        
        contentView.addSubview(horizontalStack)
        
        horizontalStack.edges(to: contentView, insets: .horizontal(16) + .vertical(13))
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10
        
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.distribution = .fill
        verticalStack.spacing = 2
        
        fallacySymbol.center(in: symbolContainerView)
        fallacySymbol.textAlignment = .center
        fallacySymbol.textColor = .white
        
        featuredStar.width(25)
        featuredStar.height(25)
        featuredStar.tintColor = .systemYellow
        
        fallacyName.textAlignment = .left
        fallacyName.numberOfLines = 0
        fallacyName.font = UIFont(name: "Museo900", size: UIFont.labelFontSize)
        
        fallacyDescription.textAlignment = .left
        fallacyDescription.numberOfLines = 0
        fallacyDescription.font = UIFont(name: "Museo300", size: UIFont.smallSystemFontSize)
        fallacyDescription.textColor = .secondaryLabel
    }
}
