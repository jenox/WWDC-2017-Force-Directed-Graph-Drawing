import UIKit


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public class ForceDirectedManager: ForceDirectedDynamicItemDelegate {
    public typealias Graph = UndirectedGraph
    public typealias Vertex = Graph.Vertex
    public typealias Delegate = ForceDirectedManagerDelegate


    // MARK: - Initialization

    public init(graph: Graph) {
        var items: [Vertex: ForceDirectedDynamicItem] = [:]

        for vertex in graph.vertices {
            let item = ForceDirectedDynamicItem(vertex: vertex)
            item.center = .zero

            items[vertex] = item
        }

        self.graph = graph
        self.items = items

        for item in items.values {
            item.delegate = self
        }
    }



    // MARK: - Stored Properties

    public weak var delegate: Delegate? = nil

    public let graph: Graph

    private let items: [Vertex: ForceDirectedDynamicItem]



    // MARK: - Helper Methods

    public func randomizeLocations(within bounds: CGRect) {
        let size = ForceDirectedDynamicItem.size
        let rect = bounds.scaled(by: 0.5, around: bounds.center).insetBy(dx: size.width / 2, dy: size.height / 2)

        for item in items.values {
            item.center = CGPoint.random(within: rect)
        }
    }

    public func dynamicItem(for vertex: Vertex) -> UIDynamicItem {
        return self.items[vertex]!
    }

    public var dynamicItems: [UIDynamicItem] {
        return Array(self.items.values)
    }

    public func location(of vertex: Vertex) -> CGPoint {
        return self.dynamicItem(for: vertex).center
    }

    public var locations: [Vertex: CGPoint] {
        var locations: [Vertex: CGPoint] = [:]

        for (vertex, item) in self.items {
            locations[vertex] = item.center
        }

        return locations
    }

    public func dynamicItemDidChange(_ item: ForceDirectedDynamicItem) {
        self.delegate?.move(item.vertex, to: item.center)
    }



    // MARK: - Dynamic Behaviors

    public func compositeBehavior(excluding vertices: Set<Vertex>) -> UIDynamicBehavior {
        let properties = UIDynamicItemBehavior(items: self.dynamicItems)
        properties.resistance = 15

        let composite = UIDynamicBehavior()
        composite.addChildBehavior(properties)

        for vertex in self.graph.vertices {
            let repulsion = self.repulsion(around: vertex, excluding: vertices)
            let attraction = self.attraction(towards: vertex, excluding: vertices)

            composite.addChildBehavior(repulsion)
            composite.addChildBehavior(attraction)
        }

        return composite
    }

    private func repulsion(around vertex: Vertex, excluding vertices: Set<Vertex>) -> UIDynamicBehavior {
        let field = UIFieldBehavior.field(evaluationBlock: { (field, position, velocity, mass, charge, delta) -> CGVector in
            let center = self.location(of: vertex)

            let distance = center.distance(to: position)
            let direction = CGVector(from: center, to: position)

            let strength = 6400 * 1 / pow(distance, 2)
            let force = direction.with(length: strength)

            return force
        })

        for other in self.graph.vertices {
            guard !vertices.contains(other) && vertex != other else {
                continue
            }

            field.addItem(self.dynamicItem(for: other))
        }

        return field
    }

    private func attraction(towards vertex: Vertex, excluding vertices: Set<Vertex>) -> UIDynamicBehavior {
        let field = UIFieldBehavior.field(evaluationBlock: { (field, position, velocity, mass, charge, delta) -> CGVector in
            let center = self.location(of: vertex)

            let distance = center.distance(to: position)
            let direction = CGVector(from: position, to: center)

            let strength = 0.064 * (distance - 60)
            let force = direction.with(length: strength)

            return force
        })

        for other in self.graph.vertices(adjacentTo: vertex) {
            guard !vertices.contains(other) && vertex != other else {
                continue
            }

            field.addItem(self.dynamicItem(for: other))
        }

        return field
    }
}
