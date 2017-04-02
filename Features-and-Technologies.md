> “Tell us about the features and technologies you used in your Swift playground.” ― Apple

Force-directed algorithms are a family of graph drawing algorithms based on physical phenomena. In a force-directed algorithm, the input graph is regarded as a particle system in which every vertex is represented as a particle. One then defines multiple forces between said particles that act to bring the system into a state of equilibrium which generally corresponds to an aesthetically pleasing drawing of the graph.

In this playground, a momentum-based force-directed algorithm is implemented. UIKit Dynamics drives the physical simulation: Each vertex is represented by a `UIDynamicItem` and the forces are realized as multiple `UIFieldBehavior`s. In each step of the algorithm, the graph is visualized using CoreGraphics drawing primitives. Using multi-touch, the user can make manual adjustments to the drawing. While vertices are being dragged, they do not participate in the physical simulation.

Swift Extensions are used heavily to extend fundamental CoreGraphics types, making common operations even easier to implement.

The input graph is parsed using `NSXMLParser`. Here Swift Enumerations with associated values are used to represent the mutually exclusive states the parser can be in.

The data structure for graphs is implemented as a value type with copy-on-write behavior, allowing for safe code when passing graphs along to other parts of the application.
