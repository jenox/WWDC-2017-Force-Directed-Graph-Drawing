import UIKit


/**
 * TODO: Description.
 *
 * - Author: christian.schnorr@me.com
 */
public class DemoViewController: UITableViewController {

    // MARK: - Initialization

    public init() {
        self.items = [
            DemoItem(title: "grafo133.16", description: "16 vertices; sparse"),
            DemoItem(title: "grafo192.13", description: "13 vertices; a little denser"),
            DemoItem(title: "grafo144.12", description: "12 vertices; tree"),
            DemoItem(title: "grafo204.15", description: "15 vertices; tree-like"),
            DemoItem(title: "grafo195.15", description: "15 vertices; dense"),
            DemoItem(title: "grafo197.15", description: "15 vertices; tree-like"),
            DemoItem(title: "grafo199.13", description: "13 vertices; pretty dense"),
            DemoItem(title: "grafo201.13", description: "13 vertices; a little sparser"),
        ]

        super.init(style: .plain)

        self.title = "Force-Directed Graph Drawing"
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }



    // MARK: - Items

    private var items: [DemoItem] {
        didSet { self.tableView.reloadData() }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel!.text = self.items[indexPath.row].title
        cell.detailTextLabel!.text = self.items[indexPath.row].description
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]

        let controller = ForceDirectedViewController(graph: item.graph)
        controller.title = item.title
        controller.view.bounds = self.view.bounds

        self.navigationController!.pushViewController(controller, animated: true)
    }
}
