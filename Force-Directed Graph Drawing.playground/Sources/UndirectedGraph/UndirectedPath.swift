import Swift


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public struct UndirectedPath: Equatable, Hashable {
    public typealias Vertex = UndirectedVertex
    public typealias Edge = UndirectedEdge


    // MARK: - Initialization

    /// - Complexity: Θ(1).
    public init(from tail: Vertex) {
        self.vertices = [tail]
        self.edges = []
        self.unorderedVertices = [tail]
        self.unorderedEdges = []
    }



    // MARK: - Stored Properties

    private(set) public var vertices: [Vertex]
    private(set) public var edges: [Edge]
    private var unorderedVertices: Set<Vertex>
    private var unorderedEdges: Set<Edge>


    // MARK: - Mutation

    /// - Complexity: Amortized Θ(1).
    public mutating func append(_ edge: Edge) {
        precondition(!self.contains(edge))
        precondition(self.contains(edge.first) != self.contains(edge.second))

        let head = edge.head(from: self.head)

        self.vertices.append(head)
        self.edges.append(edge)
        self.unorderedVertices.insert(head)
        self.unorderedEdges.insert(edge)
    }

    /// - Complexity: O(n), where n is the path's length.
    public mutating func prepend(_ edge: Edge) {
        precondition(!self.contains(edge))
        precondition(self.contains(edge.first) != self.contains(edge.second))

        let tail = edge.tail(to: self.tail)

        self.edges.insert(edge, at: 0)
        self.vertices.insert(tail, at: 0)
        self.unorderedVertices.insert(head)
        self.unorderedEdges.insert(edge)
    }



    // MARK: - Computed Properties

    /// - Complexity: Θ(1).
    public var numberOfVertices: Int {
        return self.vertices.count
    }

    /// - Complexity: Θ(1).
    public var numberOfEdges: Int {
        return self.edges.count
    }

    /// - Complexity: Θ(1).
    public var tail: Vertex {
        return self.vertices.first!
    }

    /// - Complexity: Θ(1).
    public var head: Vertex {
        return self.vertices.last!
    }

    /// - Complexity: Θ(1).
    public var internalVertices: ArraySlice<Vertex> {
        return self.vertices.dropFirst().dropLast()
    }

    /// - Complexity: Θ(1).
    public var isEmpty: Bool {
        return self.edges.isEmpty
    }

    /// - Complexity: Θ(1).
    public var length: Int {
        return self.edges.count
    }



    // MARK: - Miscellaneous

    /// - Complexity: Θ(1).
    public func contains(_ edge: Edge) -> Bool {
        return self.unorderedEdges.contains(edge)
    }

    /// - Complexity: Θ(1).
    public func contains(_ vertex: Vertex) -> Bool {
        return self.unorderedVertices.contains(vertex)
    }

    /// - Complexity: Θ(n), where n is the path's length.
    public func reversed() -> UndirectedPath {
        var copy = self
        copy.vertices = self.vertices.reversed()
        copy.edges = self.edges.reversed()

        return copy
    }



    // MARK: - Operators

    /// - Complexity: Θ(n), where n is the path's current length.
    public var hashValue: Int {
        return HashHelper.combine(self.edges)
    }

    /// - Complexity: Θ(n+m), where n and m are the paths' lengths.
    public static func ==(lhs: UndirectedPath, rhs: UndirectedPath) -> Bool {
        return lhs.vertices == rhs.vertices && lhs.edges == rhs.edges
    }
}



// MARK: - Custom String Convertible

extension UndirectedPath: CustomStringConvertible {
    public var description: String {
        return self.vertices.map({ String(describing: $0) }).joined(separator: "›")
    }
}
