import UIKit
import PlaygroundSupport


do {
    // Also try those:
    // - grafo133.16 (16 vertices)
    // - grafo192.13 (13 vertices, a little denser)
    // - grafo144.12 (12 vertices, tree)
    // - grafo204.15 (15 vertices, tree-like)

    let url = Bundle.main.url(forResource: "grafo133.16", withExtension: "graphml")!
//    let url = Bundle.main.url(forResource: "grafo192.13", withExtension: "graphml")!
//    let url = Bundle.main.url(forResource: "grafo144.12", withExtension: "graphml")!
//    let url = Bundle.main.url(forResource: "grafo204.15", withExtension: "graphml")!

    let data = try! Data(contentsOf: url)
    let graph = UndirectedGraph(data: data)!

    let controller = ForceDirectedViewController(graph: graph)

    PlaygroundPage.current.liveView = controller
}
