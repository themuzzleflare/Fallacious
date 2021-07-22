import UIKit
import TinyConstraints

final class AnimationsCell: UITableViewCell {
    static let reuseIdentifier = "animationsCell"
    
    private let sc = UISwitch()
    
    private var animationsObserver: NSKeyValueObservation?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        animationsObserver = appDefaults.observe(\.animations, options: .new) { object, change in
            self.sc.setOn(change.newValue!, animated: true)
        }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

private extension AnimationsCell {
    private func configure() {
        selectionStyle = .none
        
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = UIFont(name: "Museo900", size: UIFont.labelFontSize)
        label.text = "Animations"
        
        sc.onTintColor = UIColor(named: "AccentColor")
        sc.setOn(appDefaults.animations, animated: false)
        sc.addTarget(self, action: #selector(toggleAnimations), for: .valueChanged)
        
        let horizontalStack = UIStackView(arrangedSubviews: [label, sc])
        
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .equalSpacing
        
        contentView.addSubview(horizontalStack)
        
        horizontalStack.edges(to: contentView, insets: .horizontal(16) + .vertical(13))
    }
    
    @objc private func toggleAnimations() {
        appDefaults.animations = sc.isOn
    }
}
