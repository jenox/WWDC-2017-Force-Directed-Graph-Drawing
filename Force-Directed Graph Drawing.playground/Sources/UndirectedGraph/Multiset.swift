import Foundation


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public struct Multiset<T: Hashable> {

    // MARK: - Initialization

    public init() {
        self.multiplicities = [:]
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        self.init()

        for element in sequence {
            self.insert(element)
        }
    }


    // MARK: - Representation

    fileprivate var multiplicities: [T: Int]

    fileprivate mutating func adjustMultiplicity(of member: T, _ closure: (Int) -> Int) {
        let oldValue = self.multiplicity(of: member)
        let newValue = closure(oldValue)

        if newValue > 0 {
            self.multiplicities[member] = newValue
        }
        else {
            self.multiplicities[member] = nil
        }
    }

    public func multiplicity(of member: T) -> Int {
        return self.multiplicities[member] ?? 0
    }



    // MARK: - Core Operations

    public var isEmpty: Bool {
        return self.multiplicities.isEmpty
    }

    public var count: Int {
        return self.multiplicities.reduce(0, { $0 + $1.value })
    }

    public func count(of member: T) -> Int {
        return self.multiplicities[member] ?? 0
    }

    public func contains(_ element: T) -> Bool {
        return self.count(of: element) > 0
    }

    public mutating func insert(_ element: T) {
        self.adjustMultiplicity(of: element, { $0 + 1 })
    }

    @discardableResult
    public mutating func remove(_ element: T) -> T? {
        guard self.contains(element) else {
            return nil
        }

        self.adjustMultiplicity(of: element, { $0 - 1 })

        return element
    }
}



// MARK: - Sequence

extension Multiset: Sequence {
    public typealias Iterator = AnyIterator<T>
    public typealias SubSequence = AnySequence<T>

    public var underestimatedCount: Int {
        return self.multiplicities.underestimatedCount
    }

    public func makeIterator() -> AnyIterator<T> {
        var iterator = self.multiplicities.makeIterator()
        var current: (T, Int)? = nil

        return AnyIterator({
            guard let (member, multiplicity) = current ?? iterator.next() else {
                return nil
            }

            if multiplicity > 1 {
                current = (member, multiplicity - 1)
            }
            else {
                current = nil
            }

            return member
        })
    }
}



// MARK: - Equatable & Hashable

extension Multiset: Equatable, Hashable {
    public static func ==(lhs: Multiset, rhs: Multiset) -> Bool {
        return lhs.multiplicities == rhs.multiplicities
    }

    public var hashValue: Int {
        var hash = self.multiplicities.count.hashValue

        for (member, multiplicity) in self.multiplicities {
            hash ^= member.hashValue ^ multiplicity.hashValue
        }

        return hash
    }
}



// MARK: - Expressible By Array Literal

extension Multiset: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}



// MARK: - Custom String Convertible

extension Multiset: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return Array(self).description
    }

    public var debugDescription: String {
        return Array(self).debugDescription
    }
}
