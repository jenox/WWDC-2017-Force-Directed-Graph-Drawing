import UIKit


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public class ForceDirectedGraphView: UIView {
    public typealias Graph = UndirectedGraph
    public typealias Vertex = Graph.Vertex
    public typealias Edge = Graph.Edge


    // MARK: - Initialization

    public init(graph: Graph) {
        self.graph = graph
        self.locations = [:]

        super.init(frame: UIScreen.main.bounds)

        self.backgroundColor = .white
        self.isMultipleTouchEnabled = true
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }



    // MARK: - Configuration

    public let graph: Graph

    public var locations: [Vertex: CGPoint] {
        didSet { self.setNeedsDisplay() }
    }



    // MARK: - Rendering

    public func location(of vertex: Vertex) -> CGPoint {
        return self.locations[vertex]!
    }

    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        for edge in self.graph.edges {
            self.draw(edge, in: context)
        }

        for vertex in self.graph.vertices {
            self.draw(vertex, in: context)
        }
    }

    private func draw(_ vertex: Vertex, in context: CGContext) {
        let center = self.location(of: vertex)
        let rect = CGRect(center: center, size: ForceDirectedDynamicItem.size)

        context.saveGState()
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: rect)
        context.restoreGState()
    }

    private func draw(_ edge: Edge, in context: CGContext) {
        let start = self.location(of: edge.first)
        let end = self.location(of: edge.second)

        context.saveGState()
        context.beginPath()
        context.setLineCap(.round)
        context.setLineWidth(2)
        context.move(to: start)
        context.addLine(to: end)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        context.restoreGState()
    }
}
