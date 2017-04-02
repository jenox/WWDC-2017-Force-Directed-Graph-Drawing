import CoreGraphics


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public protocol CGGeometryAffineTransformable {
    associatedtype TransformedSelf = Self

    func applying(_ transform: CGAffineTransform) -> TransformedSelf
}



// MARK: - Default Implementations

extension CGGeometryAffineTransformable {
    public func applying(_ transform: CGAffineTransform, around center: CGPoint) -> TransformedSelf {
        return self.applying(transform.relative(to: center))
    }

    public func displaced(by vector: CGVector) -> TransformedSelf {
        let transform = vector.displacement

        return self.applying(transform)
    }

    public func scaled(by factor: CGFloat, around center: CGPoint = .zero) -> TransformedSelf {
        let transform = CGAffineTransform(a: factor, b: 0, c: 0, d: factor, tx: 0, ty: 0)

        return self.applying(transform.relative(to: center))
    }

    public func rotated(by angle: CGAngle, around center: CGPoint = .zero) -> TransformedSelf {
        let transform = angle.rotation

        return self.applying(transform.relative(to: center))
    }
}



// MARK: - Default Mutators

extension CGGeometryAffineTransformable where TransformedSelf == Self {
    public mutating func apply(_ transform: CGAffineTransform, around center: CGPoint = .zero) {
        self = self.applying(transform, around: center)
    }

    public mutating func displace(by vector: CGVector) {
        self = self.displaced(by: vector)
    }

    public mutating func scale(by factor: CGFloat, around center: CGPoint = .zero) {
        self = self.scaled(by: factor, around: center)
    }

    public mutating func rotate(by angle: CGAngle, around center: CGPoint = .zero) {
        self = self.rotated(by: angle, around: center)
    }
}



// MARK: - Protocol Conformances

extension CGPoint: CGGeometryAffineTransformable {
}

extension CGSize: CGGeometryAffineTransformable {
}

extension CGRect: CGGeometryAffineTransformable {
}

extension CGVector: CGGeometryAffineTransformable {
    public func applying(_ transform: CGAffineTransform) -> CGVector {
        let dx = transform.a * self.dx + transform.c * self.dy
        let dy = transform.b * self.dx + transform.d * self.dy

        return CGVector(dx: dx, dy: dy)
    }
}

extension CGPath: CGGeometryAffineTransformable {
    public func applying(_ transform: CGAffineTransform) -> CGPath {
        let path = CGMutablePath()
        path.addPath(self, transform: transform)

        return path
    }
}

extension CGAffineTransform: CGGeometryAffineTransformable {
    public func applying(_ transform: CGAffineTransform) -> CGAffineTransform {
        return self.concatenating(transform)
    }
}
