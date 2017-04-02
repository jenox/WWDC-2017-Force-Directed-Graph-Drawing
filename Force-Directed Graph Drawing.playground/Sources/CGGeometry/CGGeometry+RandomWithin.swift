import CoreGraphics


// MARK: - Random Values

extension CGFloat {
    public static func random(within range: ClosedRange<CGFloat>) -> CGFloat {
        let factor = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let number = range.lowerBound + factor * (range.upperBound - range.lowerBound)

        return number
    }
}

extension CGPoint {
    public static func random(within rect: CGRect) -> CGPoint {
        let x = CGFloat.random(within: rect.minX...rect.maxX)
        let y = CGFloat.random(within: rect.minY...rect.maxY)

        return CGPoint(x: x, y: y)
    }
}
