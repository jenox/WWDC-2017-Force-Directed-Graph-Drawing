import CoreGraphics



extension CGRect {
    public init(center: CGPoint, size: CGSize) {
        self.init(origin: .zero, size: size)

        self.center = center
    }

    public var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self.origin.x += newValue.x - self.midX
            self.origin.y += newValue.y - self.midY
        }
    }
}


extension CGRect {
    public var area: CGFloat {
        return self.size.area
    }
}





extension CGRect {
    public mutating func divide(_ distance: CGFloat, off edge: CGRectEdge) -> CGRect {
        let tuple = self.divided(atDistance: distance, from: edge)

        self = tuple.remainder

        return tuple.slice
    }
}
