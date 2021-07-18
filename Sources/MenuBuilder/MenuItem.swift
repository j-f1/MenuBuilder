import Cocoa

/// A standard menu item.
public struct MenuItem: AnyMenuItem {
    public typealias Modifier = (NSMenuItem) -> ()
    /// An array of functions that configure the menu item instance
    /// These may be called to update an existing menu item.
    fileprivate let modifiers: [Modifier]

    /// Calls the provided closure on the `NSMenuItem`, allowing you to apply arbitrary changes.
    public func apply(_ modifier: @escaping Modifier) -> Self {
        Self(modifiers: modifiers + [modifier])
    }
    private init(modifiers: [Modifier]) {
        self.modifiers = modifiers
    }

    /// Create a menu item with the given title
    public init(_ title: String) {
        modifiers = [{ item in item.title = title }]
    }

    /// Create a menu item with the given attributed title
    public init(_ title: NSAttributedString) {
        modifiers = [{ item in
            item.title = title.string
            item.attributedTitle = title
        }]
    }

    public init(_ title: String, @MenuBuilder children: @escaping () -> [NSMenuItem?]) {
        modifiers = [{ item in
            item.title = title
            item.submenu = NSMenu(title: title)
            item.submenu!.items = children().compactMap { $0 }
        }]
    }
}

public struct CustomMenuItem<Item: NSMenuItem>: AnyMenuItem {
    public typealias Modifier = (Item) -> ()

    fileprivate let makeMenu: () -> Item
    fileprivate let modifiers: [Modifier]

    public init(_ makeMenu: @autoclosure @escaping () -> Item) {
        self.makeMenu = makeMenu
        self.modifiers = []
    }

    /// Calls the provided closure on the `NSMenuItem`, allowing you to apply arbitrary changes.
    public func apply(_ modifier: @escaping Modifier) -> Self {
        Self(makeMenu: makeMenu, modifiers: modifiers + [modifier])
    }
    private init(makeMenu: @escaping () -> Item, modifiers: [Modifier]) {
        self.makeMenu = makeMenu
        self.modifiers = modifiers
    }
}

extension MenuBuilder {
    public static func buildExpression(_ expr: MenuItem?) -> [NSMenuItem] {
        if let description = expr {
            let item = NSMenuItem()
            description.modifiers.forEach { $0(item) }
            return [item]
        }
        return []
    }
    public static func buildExpression<T: NSMenuItem>(_ expr: CustomMenuItem<T>?) -> [NSMenuItem] {
        if let description = expr {
            let item = description.makeMenu()
            description.modifiers.forEach { $0(item) }
            return [item]
        }
        return []
    }
}
