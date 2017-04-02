import UIKit
import PlaygroundSupport



do {
    let vc = DemoViewController()
    let nc = UINavigationController(rootViewController: vc)
    nc.navigationBar.isTranslucent = false

    PlaygroundPage.current.liveView = nc
}
