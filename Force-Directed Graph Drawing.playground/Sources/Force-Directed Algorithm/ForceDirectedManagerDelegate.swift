import UIKit


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public protocol ForceDirectedManagerDelegate: class {
    func move(_ vertex: ForceDirectedManager.Vertex, to location: CGPoint)
}
