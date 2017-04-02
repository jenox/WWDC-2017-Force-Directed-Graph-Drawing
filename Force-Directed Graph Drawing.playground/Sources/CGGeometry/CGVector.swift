import CoreGraphics


// MARK: - Pointers

extension CGVector {
    public init(from source: CGPoint = .zero, to target: CGPoint) {
        let dx = target.x - source.x
        let dy = target.y - source.y

        self = CGVector(dx: dx, dy: dy)
    }

    public var pointee: CGPoint {
        return CGPoint(x: self.dx, y: self.dy)
    }
}


// MARK: - Mean

extension CGVector {
    public static func mean(of first: CGVector, _ others: CGVector...) -> CGVector {
        let dx = others.reduce(first.dx, { $0 + $1.dx }) / CGFloat(others.count + 1)
        let dy = others.reduce(first.dy, { $0 + $1.dy }) / CGFloat(others.count + 1)

        return CGVector(dx: dx, dy: dy)
    }
}


// MARK: - Normalization

extension CGVector {
    public var norm: CGFloat {
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }

    public var length: CGFloat {
        return self.norm
    }

    public func with(length: CGFloat) -> CGVector {
        return self * (length / self.length)
    }

    public var normalized: CGVector {
        return self.with(length: 1)
    }

    public mutating func normalize() {
        self = self.normalized
    }
}

public func abs(_ lhs: CGVector) -> CGFloat {
    return lhs.norm
}



// MARK: - Division

extension CGVector {
    public func divided(in direction: CGVector) -> (slice: CGVector, remainder: CGVector) {
        let length = direction.length

        guard !length.isZero && length.isFinite else {
            return (.zero, self)
        }

        let slice = (self * direction) / (length * length) * direction
        let remainder = self - slice

        return (slice, remainder)
    }
}



// MARK: - Displacement

extension CGVector {
    public var displacement: CGAffineTransform {
        return CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: self.dx, ty: self.dy)
    }
}



// MARK: - Addition

prefix public func +(vector: CGVector) -> CGVector {
    return vector
}

prefix public func -(vector: CGVector) -> CGVector {
    return CGVector(dx: -vector.dx, dy: -vector.dy)
}

public func +(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func -(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

public func +=(lhs: inout CGVector, rhs: CGVector) {
    lhs = lhs + rhs
}

public func -=(lhs: inout CGVector, rhs: CGVector) {
    lhs = lhs - rhs
}



// MARK: - Multiplication

public func *(scalar: CGFloat, vector: CGVector) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

public func *(vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

public func /(vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

public func *=(vector: inout CGVector, scalar: CGFloat) {
    vector = vector * scalar
}

public func /=(vector: inout CGVector, scalar: CGFloat) {
    vector = vector / scalar
}

public func *(scalar: Int, vector: CGVector) -> CGVector {
    return vector * CGFloat(scalar)
}

public func *(vector: CGVector, scalar: Int) -> CGVector {
    return vector * CGFloat(scalar)
}

public func /(vector: CGVector, scalar: Int) -> CGVector {
    return vector / CGFloat(scalar)
}

public func *=(vector: inout CGVector, scalar: Int) {
    vector = vector * scalar
}

public func /=(vector: inout CGVector, scalar: Int) {
    vector = vector / scalar
}



// MARK: - Dot Product

public func *(lhs: CGVector, rhs: CGVector) -> CGFloat {
    return lhs.dx * rhs.dx + lhs.dy * rhs.dy
}
