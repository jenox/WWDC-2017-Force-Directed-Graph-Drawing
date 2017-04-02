import CoreGraphics


// MARK: - Area

extension CGSize {
    public var area: CGFloat {
        return self.width * self.height
    }

    public var isEmpty: Bool {
        return self.width.isZero || self.height.isZero
    }
}



// MARK: - Standardization

extension CGSize {
    public var standardized: CGSize {
        return CGSize(width: fabs(self.width), height: fabs(self.height))
    }

    public mutating func standardize() {
        self = self.standardized
    }
}
