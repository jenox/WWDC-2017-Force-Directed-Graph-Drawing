import Foundation


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
internal struct DemoItem {
    public typealias Graph = UndirectedGraph

    public init(title: String, description: String) {
        let url = Bundle.main.url(forResource: title, withExtension: "graphml")!
        let data = try! Data(contentsOf: url)
        let graph = UndirectedGraph(data: data)!

        self.title = "\(title).graphml"
        self.description = description
        self.graph = graph
    }

    public let title: String
    public let description: String
    public let graph: Graph
}
