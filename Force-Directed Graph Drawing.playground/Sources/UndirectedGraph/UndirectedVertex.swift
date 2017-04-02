import Swift


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public final class UndirectedVertex: Equatable, Hashable {

    // MARK: - Initialization

    public init(name: String) {
        self.name = name
    }



    // MARK: - Stored Properties

    public let name: String



    // MARK: - Operators

    public var hashValue: Int {
        return HashHelper.combine(self.name)
    }

    public static func ==(lhs: UndirectedVertex, rhs: UndirectedVertex) -> Bool {
        return lhs === rhs
    }
}



// MARK: - Expressible By String Literal

extension UndirectedVertex: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: String) {
        self.init(name: value)
    }

    public convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }

    public convenience init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
}



// MARK: - Custom String Convertible

extension UndirectedVertex: CustomStringConvertible {
    public var description: String {
        return self.name
    }
}
