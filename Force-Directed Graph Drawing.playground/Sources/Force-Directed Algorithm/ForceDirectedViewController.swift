import UIKit


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public class ForceDirectedViewController: UIViewController, ForceDirectedManagerDelegate {
    public typealias Graph = UndirectedGraph
    public typealias Vertex = Graph.Vertex


    // MARK: - Initialization

    public init(graph: Graph) {
        self.graph = graph
        self.manager = ForceDirectedManager(graph: graph)

        self.contentView = ForceDirectedGraphView(graph: graph)
        self.contentView.locations = self.manager.locations

        self.forceDirectedBehavior = self.manager.compositeBehavior(excluding: [])

        self.boundingBoxBehavior = UICollisionBehavior(items: self.manager.dynamicItems)
        self.boundingBoxBehavior.translatesReferenceBoundsIntoBoundary = true

        super.init(nibName: nil, bundle: nil)

        self.manager.delegate = self
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }



    // MARK: - Graph Management

    private let graph: Graph

    private let contentView: ForceDirectedGraphView

    public override func loadView() {
        self.view = self.contentView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.animator == nil {
            self.manager.randomizeLocations(within: self.view.bounds)

            let animator = UIDynamicAnimator(referenceView: self.view)
            animator.addBehavior(self.forceDirectedBehavior)
            animator.addBehavior(self.boundingBoxBehavior)

            self.animator = animator
        }
    }



    // MARK: - Force Directed Algorithm

    private let manager: ForceDirectedManager

    public func move(_ vertex: Vertex, to location: CGPoint) {
        self.contentView.locations[vertex] = location
    }



    // MARK: - Dynamic Animator

    private var animator: UIDynamicAnimator? = nil

    private var forceDirectedBehavior: UIDynamicBehavior {
        willSet { self.animator?.removeBehavior(self.forceDirectedBehavior) }
        didSet { self.animator?.addBehavior(self.forceDirectedBehavior) }
    }

    private var boundingBoxBehavior: UICollisionBehavior {
        willSet { self.animator?.removeBehavior(self.boundingBoxBehavior) }
        didSet { self.animator?.addBehavior(self.boundingBoxBehavior) }
    }



    // MARK: - Touch Handling

    private var displacements: [UITouch: (Vertex, CGVector)] = [:] {
        didSet {
            let vertices = Set(self.displacements.map({ $0.value.0 }))
            let behavior = self.manager.compositeBehavior(excluding: vertices)

            self.forceDirectedBehavior = behavior
        }
    }

    private func location(of vertex: Vertex) -> CGPoint {
        return self.contentView.location(of: vertex)
    }

    private func vertex(at point: CGPoint) -> Vertex? {
        var hit: (vertex: Vertex, distance: CGFloat)? = nil

        for vertex in self.graph.vertices {
            let location = self.location(of: vertex)
            let distance = location.distance(to: point)

            guard distance <= ForceDirectedDynamicItem.size.width / 2 + 5 else {
                continue
            }

            if let current = hit?.distance, current < distance {
            }
            else {
                hit = (vertex, distance)
            }
        }

        return hit?.vertex
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.startTracking(touch)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.continueTracking(touch)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.stopTracking(touch)
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.stopTracking(touch)
        }
    }

    private func startTracking(_ touch: UITouch) {
        guard self.displacements[touch] == nil else {
            return
        }

        let location = touch.location(in: self.contentView)

        if let vertex = self.vertex(at: location) {
            let offset = CGVector(from: location, to: self.location(of: vertex))

            self.displacements[touch] = (vertex, offset)
        }
    }

    private func continueTracking(_ touch: UITouch) {
        guard let (vertex, offset) = self.displacements[touch] else {
            return
        }

        let size = ForceDirectedDynamicItem.size
        let bounds = self.contentView.bounds.insetBy(dx: size.width / 2, dy: size.height / 2)
        let location = touch.location(in: self.contentView)
        let center = location.displaced(by: offset).constrained(to: bounds)

        let item = self.manager.dynamicItem(for: vertex)
        item.center = center

        self.animator?.updateItem(usingCurrentState: item)
    }

    private func stopTracking(_ touch: UITouch) {
        guard let (_, _) = self.displacements[touch] else {
            return
        }

        self.displacements[touch] = nil
    }
}
