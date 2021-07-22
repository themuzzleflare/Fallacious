import UIKit
import Lottie
import Macaw
import TinyConstraints

final class FallacyDetailTopCell: UITableViewCell {
    static let reuseIdentifier = "fallacyDetailTopCell"
    
    var fallacy: Fallacy! {
        didSet {
            symbolLabel.font = fallacy.categoryName == "Cognitive Bias" ? UIFont(name: "ybi", size: 65) : UIFont(name: "YLF", size: 55)
            if fallacy.categoryName == "Cognitive Bias" && appDefaults.animations && (fallacy.name != "The Backfire Effect" && fallacy.name != "Confirmation Bias") {
                symbolLabel.isHidden = true
                fallacyAnimation.animation = .named(fallacy.recordID!.recordName)
                fallacyAnimation.play()
            } else {
                symbolLabel.text = fallacy.symbol
                fallacyAnimation.isHidden = true
            }
            nameLabel.text = fallacy.name.lowercased()
        }
    }
    
    private let symbolLabel = UILabel()
    private let fallacyAnimation = AnimationView()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

private extension FallacyDetailTopCell {
    private func configure() {
        selectionStyle = .none
        
        let symbolContainerView = UIView()
        
        let squareButton = SVGView()
        
        squareButton.backgroundColor = .clear
        squareButton.fileName = "square-button"
        squareButton.width(100)
        squareButton.height(100)
        
        symbolLabel.textAlignment = .center
        symbolLabel.textColor = .white
        
        fallacyAnimation.backgroundBehavior = .pauseAndRestore
        fallacyAnimation.loopMode = .playOnce
        fallacyAnimation.width(100)
        fallacyAnimation.height(100)
        
        symbolContainerView.addSubview(squareButton)
        symbolContainerView.addSubview(symbolLabel)
        symbolContainerView.addSubview(fallacyAnimation)
        
        symbolContainerView.width(100)
        symbolContainerView.height(100)
        
        symbolLabel.center(in: symbolContainerView)
        
        fallacyAnimation.center(in: symbolContainerView)
        
        nameLabel.font = UIFont(name: "Museo900", size: 32)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        
        let horizontalStack = UIStackView(arrangedSubviews: [symbolContainerView, nameLabel])
        
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 15
        
        contentView.addSubview(horizontalStack)
        
        horizontalStack.edges(to: contentView, insets: .horizontal(16) + .vertical(13))
    }
}
