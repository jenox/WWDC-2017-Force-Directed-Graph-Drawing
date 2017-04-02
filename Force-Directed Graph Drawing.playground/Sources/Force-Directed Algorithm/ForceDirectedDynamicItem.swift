import UIKit


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public class ForceDirectedDynamicItem: NSObject, UIDynamicItem {
    public typealias Vertex = UndirectedGraph.Vertex
    public typealias Delegate = ForceDirectedDynamicItemDelegate


    // MARK: - Initialization

    public init(vertex: Vertex) {
        self.vertex = vertex
        self.bounds = CGRect(origin: .zero, size: ForceDirectedDynamicItem.size)
        self.center = .zero
        self.transform = .identity

        super.init()
    }



    // MARK: - Force Directed Algorithm

    public static let size: CGSize = CGSize(width: 16, height: 16)

    public let vertex: Vertex

    public weak var delegate: Delegate? = nil



    // MARK: - Dynamic Item

    public let bounds: CGRect

    public var center: CGPoint {
        didSet { self.delegate?.dynamicItemDidChange(self) }
    }

    public var transform: CGAffineTransform {
        didSet { self.delegate?.dynamicItemDidChange(self) }
    }

    public var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}
