import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension TabBarController {
    private func configure() {
        tabBar.tintColor = UIColor(named: "AccentColor")
        
        viewControllers = [
            {
                let vc = UINavigationController(rootViewController: FallaciousVC())
                vc.tabBarItem = UITabBarItem(title: "Fallacious", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
                return vc
            }(),
            {
                let vc = UINavigationController(rootViewController: AboutVC())
                vc.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "info.circle"), selectedImage: UIImage(systemName: "info.circle.fill"))
                return vc
            }()
        ]
    }
}
