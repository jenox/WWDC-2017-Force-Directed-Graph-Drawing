import CoreGraphics


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public struct CGAngle {
    public init(turns: CGFloat) {
        guard turns.isFinite else {
            preconditionFailure()
        }

        self.turns = turns
    }

    public static func turns(_ turns: CGFloat) -> CGAngle {
        return CGAngle(turns: turns)
    }

    public let turns: CGFloat
}



// MARK: - Common Angles

extension CGAngle {
    public static let zero: CGAngle = CGAngle(degrees: 0)
    public static let quarter: CGAngle = CGAngle(degrees: 90)
    public static let half: CGAngle = CGAngle(degrees: 180)
    public static let full: CGAngle = CGAngle(degrees: 360)
}



// MARK: - Radians

extension CGAngle {
    fileprivate static let tau: CGFloat = 2 * .pi

    public init(radians: CGFloat) {
        self = CGAngle(turns: radians / CGAngle.tau)
    }

    public static func radians(_ radians: CGFloat) -> CGAngle {
        return CGAngle(radians: radians)
    }

    public var radians: CGFloat {
        return self.turns * CGAngle.tau
    }
}



// MARK: - Degrees

extension CGAngle {
    public init(degrees: CGFloat) {
        self = CGAngle(turns: degrees / 360)
    }

    public static func degrees(_ degrees: CGFloat) -> CGAngle {
        return CGAngle(degrees: degrees)
    }

    public var degrees: CGFloat {
        return self.turns * 360
    }
}



// MARK: - Equatable

extension CGAngle: Equatable {
    public static func ==(lhs: CGAngle, rhs: CGAngle) -> Bool {
        return lhs.turns == rhs.turns
    }


}



// MARK: - Comparable

extension CGAngle: Comparable {
    public static func <(lhs: CGAngle, rhs: CGAngle) -> Bool {
        return lhs.turns < rhs.turns
    }
}



// MARK: - Trigonometry

extension CGAngle {
    public static func asin(_ value: CGFloat) -> CGAngle {
        return CGAngle(radians: CoreGraphics.asin(value))
    }

    public static func acos(_ value: CGFloat) -> CGAngle {
        return CGAngle(radians: CoreGraphics.acos(value))
    }

    public static func atan(_ value: CGFloat) -> CGAngle {
        return CGAngle(radians: CoreGraphics.atan(value))
    }

    public static func atan2(_ dy: CGFloat, _ dx: CGFloat) -> CGAngle {
        guard dx != 0 || dy != 0 else {
            preconditionFailure()
        }

        return CGAngle(radians: CoreGraphics.atan2(dy, dx))
    }

    public static func asinh(_ value: CGFloat) -> CGAngle {
        return CGAngle(radians: CoreGraphics.asinh(value))
    }

    public static func acosh(_ value: CGFloat) -> CGAngle {
        return CGAngle(radians: CoreGraphics.acosh(value))
    }

    public static func atanh(_ value: CGFloat) -> CGAngle {
        return CGAngle(radians: CoreGraphics.atanh(value))
    }
}

public func sin(_ angle: CGAngle) -> CGFloat {
    let tau = 2 * CGFloat.pi
    var turns = fmod(angle.turns, 1.0)

    if turns < 0 {
        turns += 1
    }

    if turns < 0.25 {
        return 0 + sin(turns * tau)
    }
    else if turns < 0.5 {
        return 0 + sin((0.5 - turns) * tau)
    }
    else if turns < 0.75 {
        return 0 - sin((turns - 0.5) * tau)
    }
    else {
        return 0 - sin((1.0 - turns) * tau)
    }
}

public func cos(_ angle: CGAngle) -> CGFloat {
    return sin(CGAngle(turns: angle.turns + 0.25))
}

public func tan(_ angle: CGAngle) -> CGFloat {
    let numerator = sin(angle)
    let denominator = cos(angle)

    if denominator.isZero {
        return .nan
    }
    else {
        return numerator / denominator
    }
}

public func sinh(_ angle: CGAngle) -> CGFloat {
    return sinh(angle.radians)
}

public func cosh(_ angle: CGAngle) -> CGFloat {
    return cosh(angle.radians)
}

public func tanh(_ angle: CGAngle) -> CGFloat {
    return tanh(angle.radians)
}



// MARK: - Normalization

extension CGAngle {

    /// [-180°, 180°)
    public var normalized: CGAngle {
        let turns = fmod(self.turns, 1.0)

        if turns < -0.5 {
            return CGAngle(turns: turns + 1.0)
        }
        else if turns >= 0.5 {
            return CGAngle(turns: turns - 1.0)
        }
        else {
            return CGAngle(turns: turns)
        }
    }

    /// [-180°, 180°)
    public mutating func normalize() {
        self = self.normalized
    }

    /// [0°, 360°)
    public var counterclockwise: CGAngle {
        let normalized = self.normalized

        if normalized.turns < 0 {
            return CGAngle(turns: normalized.turns + 1)
        }
        else {
            return normalized
        }
    }

    /// (-360°, 0°]
    public var clockwise: CGAngle {
        let normalized = self.normalized

        if normalized.turns > 0 {
            return CGAngle(turns: normalized.turns - 1)
        }
        else {
            return normalized
        }
    }
}

public func abs(_ angle: CGAngle) -> CGAngle {
    return CGAngle(turns: fabs(angle.turns))
}



// MARK: - Geometry

extension CGAngle {
    /// [0°, 180°]
    public init(between a: CGVector, and b: CGVector) {
        self = CGAngle.acos(a.normalized * b.normalized)
    }

    /// [-180°, 180°)
    public init(from a: CGVector, to b: CGVector) {
        self = (CGAngle.atan2(b.dy, b.dx) - CGAngle.atan2(a.dy, a.dx)).normalized
    }

    /// [-180°, 180°)
    public init(from start: CGPoint, by vertex: CGPoint, to end: CGPoint) {
        let vp = CGVector(from: vertex, to: start)
        let vq = CGVector(from: vertex, to: end)
        let angle = CGAngle(from: vp, to: vq).normalized

        self = angle
    }

    /// [-180°, 180°)
    public static func slope(of vector: CGVector) -> CGAngle {
        return CGAngle.atan2(vector.dy, vector.dx).normalized
    }

    /// [-180°, 180°)
    public static func slope(from start: CGPoint, to end: CGPoint) -> CGAngle {
        return CGAngle.slope(of: CGVector(from: start, to: end))
    }
}

extension CGVector {
    public var slope: CGAngle {
        return CGAngle.slope(of: self)
    }
}

extension CGPoint {
    public func slope(to point: CGPoint) -> CGAngle {
        return CGAngle.slope(from: self, to: point)
    }
}



// MARK: - Rotation

extension CGAngle {
    public var rotation: CGAffineTransform {
        let a = cos(self)
        let b = sin(self)

        return CGAffineTransform(a: a, b: b, c: -b, d: a, tx: 0, ty: 0)
    }

    public func rotation(around center: CGPoint) -> CGAffineTransform {
        return self.rotation.relative(to: center)
    }
}



// MARK: - CustomStringConvertible

extension CGAngle: CustomStringConvertible {
    public var description: String {
        return "\(self.degrees)°"
    }
}



// MARK: - Addition

public prefix func +(angle: CGAngle) -> CGAngle {
    return angle
}

public prefix func -(angle: CGAngle) -> CGAngle {
    return CGAngle(turns: -angle.turns)
}

public func +(lhs: CGAngle, rhs: CGAngle) -> CGAngle {
    return CGAngle(turns: lhs.turns + rhs.turns)
}

public func -(lhs: CGAngle, rhs: CGAngle) -> CGAngle {
    return CGAngle(turns: lhs.turns - rhs.turns)
}

public func +=(lhs: inout CGAngle, rhs: CGAngle) {
    lhs = lhs + rhs
}

public func -=(lhs: inout CGAngle, rhs: CGAngle) {
    lhs = lhs - rhs
}



// MARK: - Multiplication

public func *(scalar: CGFloat, angle: CGAngle) -> CGAngle {
    return CGAngle(turns: angle.turns * scalar)
}

public func *(angle: CGAngle, scalar: CGFloat) -> CGAngle {
    return CGAngle(turns: angle.turns * scalar)
}

public func /(angle: CGAngle, scalar: CGFloat) -> CGAngle {
    return CGAngle(turns: angle.turns / scalar)
}

public func *=(angle: inout CGAngle, scalar: CGFloat) {
    angle = angle * scalar
}

public func /=(angle: inout CGAngle, scalar: CGFloat) {
    angle = angle / scalar
}

public func *(scalar: Int, angle: CGAngle) -> CGAngle {
    return angle * CGFloat(scalar)
}

public func *(angle: CGAngle, scalar: Int) -> CGAngle {
    return angle * CGFloat(scalar)
}

public func /(angle: CGAngle, scalar: Int) -> CGAngle {
    return angle / CGFloat(scalar)
}

public func *=(angle: inout CGAngle, scalar: Int) {
    angle = angle * scalar
}

public func /=(angle: inout CGAngle, scalar: Int) {
    angle = angle / scalar
}



// MARK: - Division

public func /(lhs: CGAngle, rhs: CGAngle) -> CGFloat {
    return lhs.turns / rhs.turns
}
