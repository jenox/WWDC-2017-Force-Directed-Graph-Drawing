import Swift


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public struct UndirectedGraph {
    public typealias Vertex = UndirectedVertex
    public typealias Edge = UndirectedEdge
    public typealias Path = UndirectedPath


    // MARK: - Initialization

    public init() {
    }



    // MARK: - Stored Properties

    private(set) public var vertices: Set<Vertex> = []
    private(set) public var edges: Set<Edge> = []
    private var incidentEdges: [Vertex: Set<Edge>] = [:]
    private var adjacentVertices: [Vertex: Multiset<Vertex>] = [:]



    // MARK: - Basic Vertex Queries

    /// - Complexity: Θ(1).
    public var numberOfVertices: Int {
        return self.vertices.count
    }

    /// - Complexity: Θ(1).
    public func contains(_ vertex: Vertex) -> Bool {
        return self.vertices.contains(vertex)
    }

    /// - Complexity: O(k), where k is the number of vertices in `vertices`.
    public func contains(_ vertices: Set<Vertex>) -> Bool {
        return self.vertices.isSubset(of: vertices)
    }

    /// - Complexity: Θ(1).
    public mutating func insert(_ vertex: Vertex) {
        guard !self.vertices.contains(vertex) else {
            preconditionFailure()
        }

        self.vertices.insert(vertex)
        self.adjacentVertices[vertex] = []
        self.incidentEdges[vertex] = []
    }

    /// - Complexity: Θ(1).
    public mutating func remove(_ vertex: Vertex) {
        guard self.vertices.contains(vertex) else {
            preconditionFailure()
        }

        let edges = self.incidentEdges[vertex]!

        for neighbor in self.adjacentVertices[vertex]! {
            self.adjacentVertices[neighbor]!.remove(vertex)
            self.incidentEdges[neighbor]!.subtract(edges)
        }

        self.adjacentVertices[vertex] = nil
        self.incidentEdges[vertex] = nil

        self.vertices.remove(vertex)
        self.edges.subtract(edges)
    }



    // MARK: - Basic Edge Queries

    /// - Complexity: Θ(1).
    public var numberOfEdges: Int {
        return self.edges.count
    }

    /// - Complexity: Θ(1).
    public func contains(_ edge: Edge) -> Bool {
        return self.edges.contains(edge)
    }

    /// - Complexity: O(k), where k is the number of edges in `edges`.
    public func contains(_ edges: Set<Edge>) -> Bool {
        return self.edges.isSuperset(of: edges)
    }

    /// - Complexity: Θ(1).
    public mutating func insert(_ edge: Edge) {
        guard !self.contains(edge) else {
            preconditionFailure()
        }

        guard self.contains(edge.first) && self.contains(edge.second) else {
            preconditionFailure()
        }

        self.incidentEdges[edge.first]!.insert(edge)
        self.adjacentVertices[edge.first]!.insert(edge.second)

        if edge.first !== edge.second {
            self.incidentEdges[edge.second]!.insert(edge)
            self.adjacentVertices[edge.second]!.insert(edge.first)
        }

        self.edges.insert(edge)
    }

    /// - Complexity: Θ(1).
    public mutating func remove(_ edge: Edge) {
        guard self.contains(edge) else {
            preconditionFailure()
        }

        self.incidentEdges[edge.first]!.remove(edge)
        self.adjacentVertices[edge.first]!.remove(edge.second)

        if edge.first !== edge.second {
            self.incidentEdges[edge.second]!.remove(edge)
            self.adjacentVertices[edge.second]!.remove(edge.first)
        }

        self.edges.remove(edge)
    }



    // MARK: - Advanced Queries

    /// - Complexity: Θ(1).
    public func edges(incidentTo vertex: Vertex) -> Set<Edge> {
        return self.incidentEdges[vertex]!
    }

    /// - Complexity: Θ(k), where k is the number of edges incident to `edge`.
    public func edges(incidentTo edge: Edge) -> Set<Edge> {
        let first = self.edges(incidentTo: edge.first)
        let second = self.edges(incidentTo: edge.second)

        return first.union(second)
    }

    /// - Complexity: Θ(k), where k is the number of edges incident to `u`.
    public func edges(between u: Vertex, and v: Vertex) -> Set<Edge> {
        return Set(self.edges(incidentTo: u).filter({ $0.contains(v) }))
    }

    /// - Complexity: O(m), where m is the number of edges in the graph.
    public func edges(matching predicate: (Edge) -> Bool) -> Set<Edge> {
        return Set(self.edges.filter(predicate))
    }

    /// - Complexity: Θ(1).
    public func vertices(adjacentTo vertex: Vertex) -> Multiset<Vertex> {
        return self.adjacentVertices[vertex]!
    }

    /// - Complexity: O(n), where n is the number of vertices in the graph.
    public func vertices(matching predicate: (Vertex) -> Bool) -> Multiset<Vertex> {
        return Multiset(self.vertices.filter(predicate))
    }

    /// - Complexity: O(1).
    public func degree(of vertex: Vertex) -> Int {
        let neighbors = self.vertices(adjacentTo: vertex)
        let numberOfLoops = neighbors.count(of: vertex)
        let numberOfNonLoops = neighbors.count - numberOfLoops

        return numberOfNonLoops + 2 * numberOfLoops
    }
}



// MARK: - Custom String Convertible

extension UndirectedGraph: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let comparator = { (lhs: Vertex, rhs: Vertex) -> Bool in
            return lhs.name < rhs.name
        }

        return self.vertices.sorted(by: comparator).map({
            return "\($0): \(self.vertices(adjacentTo: $0).sorted(by: comparator))"
        }).joined(separator: "\n")
    }

    public var debugDescription: String {
        return "UndirectedGraph(n=\(self.vertices.count), m=\(self.edges.count))"
    }
}
