import Cocoa

class MenuInvoker {
    static let shared = MenuInvoker()
    private init() {}
    @objc func run(_ item: NSMenuItem) {
        (item.representedObject as! () -> ())()
    }
}
