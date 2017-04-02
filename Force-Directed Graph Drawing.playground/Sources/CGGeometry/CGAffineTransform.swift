import CoreGraphics


// MARK: - Combination

extension CGAffineTransform {
    public func prepending(_ transform: CGAffineTransform) -> CGAffineTransform {
        return transform.concatenating(self)
    }

    public func appending(_ transform: CGAffineTransform) -> CGAffineTransform {
        return self.concatenating(transform)
    }

    public mutating func prepend(_ transform: CGAffineTransform) {
        self = self.prepending(transform)
    }

    public mutating func append(_ transform: CGAffineTransform) {
        self = self.appending(transform)
    }

    public mutating func concatenate(_ transform: CGAffineTransform) {
        self = self.concatenating(transform)
    }
}



// MARK: - Reference Point

extension CGAffineTransform {
    public func relative(to center: CGPoint) -> CGAffineTransform {
        let back = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: -center.x, ty: -center.y)
        let forth = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: +center.x, ty: +center.y)

        return self.prepending(back).appending(forth)
    }
}



// MARK: - Inversion

extension CGAffineTransform {
    public mutating func invert() {
        self = self.inverted()
    }
}
