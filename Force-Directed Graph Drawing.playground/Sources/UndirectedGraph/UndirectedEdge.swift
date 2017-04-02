import Swift


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public final class UndirectedEdge: Equatable, Hashable {
    public typealias Vertex = UndirectedVertex


    // MARK: - Initialization

    public init(between first: Vertex, and second: Vertex) {
        self.first = first
        self.second = second
    }



    // MARK: - Stored Properties

    public let first: Vertex
    public let second: Vertex



    // MARK: - Helper Functions

    public var isLoop: Bool {
        return self.first == self.second
    }

    public func contains(_ vertex: Vertex) -> Bool {
        return self.first == vertex || self.second == vertex
    }

    public func head(from tail: Vertex) -> Vertex {
        precondition(self.contains(tail))

        return self.first == tail ? self.second : self.first
    }

    public func tail(to head: Vertex) -> Vertex {
        precondition(self.contains(head))

        return self.first == head ? self.second : self.first
    }



    // MARK: - Operators

    public var hashValue: Int {
        return HashHelper.combine(self.first, self.second)
    }

    public static func ==(lhs: UndirectedEdge, rhs: UndirectedEdge) -> Bool {
        return lhs === rhs
    }
}



// MARK: - Custom String Convertible

extension UndirectedEdge: CustomStringConvertible {
    public var description: String {
        return "{\(self.first), \(self.second)}"
    }
}
