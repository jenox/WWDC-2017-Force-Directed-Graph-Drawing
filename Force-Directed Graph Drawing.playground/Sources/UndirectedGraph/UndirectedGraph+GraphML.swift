import Foundation


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
extension UndirectedGraph {
    public init?(data: Data) {
        guard let parser = try? GraphMLParser(data: data) else {
            return nil
        }

        self.init()

        var vertices: [String: Vertex] = [:]

        for name in parser.vertices {
            let vertex = Vertex(name: name)
            vertices[name] = vertex

            self.insert(vertex)
        }

        for (first, second) in parser.edges {
            self.insert(Edge(between: vertices[first]!, and: vertices[second]!))
        }
    }
}



// MARK: - Parser

private class GraphMLParser: NSObject, XMLParserDelegate {
    public init(data: Data) throws {
        super.init()

        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()

        if case .failed(let error) = self.state {
            throw error
        }

        guard case .doneWithDocument(let vertices, let edges) = self.state else {
            fatalError()
        }

        for (source, target) in edges {
            guard vertices.contains(source) else {
                throw Error.uncategorized
            }

            guard vertices.contains(target) else {
                throw Error.uncategorized
            }
        }
    }

    private enum State {
        case waitingForDocument
        case parsingDocument
        case parsingGraphML
        case parsingGraph(Set<String>, [(String, String)])
        case parsingVertex(Set<String>, [(String, String)])
        case parsingEdge(Set<String>, [(String, String)])
        case doneWithGraph(Set<String>, [(String, String)])
        case doneWithGraphML(Set<String>, [(String, String)])
        case doneWithDocument(Set<String>, [(String, String)])
        case failed(Swift.Error)
    }

    private var state: State = .waitingForDocument

    public var vertices: Set<String> {
        guard case .doneWithDocument(let vertices, _) = self.state else {
            preconditionFailure()
        }

        return vertices
    }

    public var edges: [(String, String)] {
        guard case .doneWithDocument(_, let edges) = self.state else {
            preconditionFailure()
        }

        return edges
    }

    public func parserDidStartDocument(_ parser: XMLParser) {
        guard case .waitingForDocument = self.state else {
            preconditionFailure()
        }

        self.state = .parsingDocument
    }

    public func parser(_ parser: XMLParser, didStartElement tag: String, namespaceURI: String?, qualifiedName: String?, attributes: [String: String] = [:]) {
        if tag == "graphml" {
            guard case .parsingDocument = self.state else {
                return parser.abortParsing()
            }

            self.state = .parsingGraphML
        }
        else if tag == "graph" {
            guard case .parsingGraphML = self.state else {
                return parser.abortParsing()
            }

            self.state = .parsingGraph([], [])
        }
        else if tag == "node" {
            guard case .parsingGraph(var vertices, let edges) = self.state else {
                return parser.abortParsing()
            }

            guard let name = attributes["id"] else {
                return parser.abortParsing()
            }

            guard vertices.insert(name).inserted else {
                return parser.abortParsing()
            }

            self.state = .parsingVertex(vertices, edges)
        }
        else if tag == "edge" {
            guard case .parsingGraph(let vertices, var edges) = self.state else {
                return parser.abortParsing()
            }

            guard let source = attributes["source"] else {
                return parser.abortParsing()
            }

            guard let target = attributes["target"] else {
                return parser.abortParsing()
            }

            edges.append((source, target))

            self.state = .parsingEdge(vertices, edges)
        }
    }

    public func parser(_ parser: XMLParser, didEndElement tag: String, namespaceURI: String?, qualifiedName: String?) {
        if tag == "edge" {
            guard case .parsingEdge(let vertices, let edges) = self.state else {
                return parser.abortParsing()
            }

            self.state = .parsingGraph(vertices, edges)
        }
        else if tag == "node" {
            guard case .parsingVertex(let vertices, let edges) = self.state else {
                return parser.abortParsing()
            }

            self.state = .parsingGraph(vertices, edges)
        }
        else if tag == "graph" {
            guard case .parsingGraph(let vertices, let edges) = self.state else {
                return parser.abortParsing()
            }

            self.state = .doneWithGraph(vertices, edges)
        }
        else if tag == "graphml" {
            guard case .doneWithGraph(let vertices, let edges) = self.state else {
                return parser.abortParsing()
            }

            self.state = .doneWithGraphML(vertices, edges)
        }
    }

    public func parserDidEndDocument(_ parser: XMLParser) {
        guard case .doneWithGraphML(let vertices, let edges) = self.state else {
            return self.state = .failed(Error.uncategorized)
        }

        self.state = .doneWithDocument(vertices, edges)
    }

    public func parser(_ parser: XMLParser, parseErrorOccurred error: Swift.Error) {
        self.state = .failed(error)
    }

    private enum Error: Swift.Error {
        case uncategorized
    }
}
