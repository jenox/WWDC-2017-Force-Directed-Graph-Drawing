import CoreGraphics


// MARK: - CustomStringConvertible

extension CGRectEdge: CustomStringConvertible {
    public var description: String {
        switch self {
        case .minXEdge: return "minXEdge"
        case .minYEdge: return "minYEdge"
        case .maxXEdge: return "maxXEdge"
        case .maxYEdge: return "maxYEdge"
        }
    }
}
