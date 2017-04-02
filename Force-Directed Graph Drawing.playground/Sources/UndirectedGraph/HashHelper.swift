import Swift


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public struct HashHelper {
    private init() {
    }

    // http://stackoverflow.com/a/35991300/
    private static func fold(hashes: [Int]) -> Int {
        var pattern: UInt = 0

        for hash in hashes {
            pattern ^= UInt(bitPattern: hash) &+ 0x9e3779b9 &+ (pattern << 6) &+ (pattern >> 2)
        }

        return Int(bitPattern: pattern)
    }

    private static func fold(hashes: Int...) -> Int {
        return self.fold(hashes: hashes)
    }

    public static func combine<T: Hashable>(_ items: [T]) -> Int {
        return self.fold(hashes: items.map({ $0.hashValue }))
    }

    public static func combine<A: Hashable>(_ a: A) -> Int {
        return self.fold(hashes: a.hashValue)
    }

    public static func combine<A: Hashable, B: Hashable>(_ a: A, _ b: B) -> Int {
        return self.fold(hashes: a.hashValue, b.hashValue)
    }

    public static func combine<A: Hashable, B: Hashable, C: Hashable>(_ a: A, _ b: B, _ c: C) -> Int {
        return self.fold(hashes: a.hashValue, b.hashValue, c.hashValue)
    }

    public static func combine<A: Hashable, B: Hashable, C: Hashable, D: Hashable>(_ a: A, _ b: B, _ c: C, _ d: D) -> Int {
        return self.fold(hashes: a.hashValue, b.hashValue, c.hashValue, d.hashValue)
    }

    public static func combine<A: Hashable, B: Hashable, C: Hashable, D: Hashable, E: Hashable>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> Int {
        return self.fold(hashes: a.hashValue, b.hashValue, c.hashValue, d.hashValue, e.hashValue)
    }

    public static func combine<A: Hashable, B: Hashable, C: Hashable, D: Hashable, E: Hashable, F: Hashable>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> Int {
        return self.fold(hashes: a.hashValue, b.hashValue, c.hashValue, d.hashValue, e.hashValue, f.hashValue)
    }
}
