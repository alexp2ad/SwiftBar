import Foundation

class PluginManager {
    static let shared = PluginManager()
    let barItem = MenubarItem.defaultBarItem()
    var plugins: [Plugin] = [] {
        didSet {
            pluginsDidChange()
        }
    }
    var menuBarItems: [PluginID: MenubarItem] = [:]
    var pluginsFolder: String = "" {
        didSet {
            loadPlugins()
        }
    }

    init() {
        if plugins.isEmpty {
            barItem.show()
        }
    }

    func pluginsDidChange() {
        plugins.forEach{ plugin in
            guard menuBarItems[plugin.id] == nil else {return}
            menuBarItems[plugin.id] = MenubarItem(title: plugin.name)
        }
        plugins.isEmpty ? barItem.show():barItem.hide()
    }

    func addPlugin(from file: String) {

    }

    func addDummyPlugin() {
        plugins.append(ExecutablePlugin(name: "New", file: UUID().uuidString, metadata: PluginMetadata()))
    }
    
    /// Scan pluginsFolder for all potential scripts
    func loadPlugins() {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: pluginsFolder, isDirectory: &isDir), isDir.boolValue else {
            plugins.removeAll()
            menuBarItems.removeAll()
            barItem.show()
            return
        }
        barItem.hide()
    }
}
