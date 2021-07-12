import Cocoa
#if canImport(SwiftUI)
import SwiftUI
#endif

public protocol AnyMenuItem {
    associatedtype Item: NSMenuItem
    func apply(_ modifier: @escaping (Item) -> ()) -> Self
}

/// A standard menu item
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

extension AnyMenuItem {
    /// Set an arbitrary `keyPath` on the menu item to a value of your choice.
    /// Most of the other modifiers are just sugar wrapping this.
    public func set<Value>(_ keyPath: ReferenceWritableKeyPath<Item, Value>, to value: Value) -> Self {
        apply {
            $0[keyPath: keyPath] = value
        }
    }

    /// Set the key equivalent (i.e. `.shortcut("c")` for ⌘C)
    public func shortcut(_ shortcut: String, holding modifiers: NSEvent.ModifierFlags = .command) -> Self {
        apply {
            $0.keyEquivalent = shortcut
            $0.keyEquivalentModifierMask = modifiers
        }
    }

    /// Run a closure when the menu item is selected
    public func onSelect(_ handler: @escaping () -> ()) -> Self {
        apply {
            $0.representedObject = handler
            $0.target = MenuInvoker.shared
            $0.action = #selector(MenuInvoker.run(_:))
        }
    }

    /// disable or enable the menu item.
    /// NOTE: menu items can only be enabled if they have a select handler or a submenu
    /// so `MenuItem("hello")` will always be disabled
    public func disabled(_ disabled: Bool = true) -> Self {
        set(\.isEnabled, to: !disabled)
    }

    /// Set the checked/unchecked state
    public func state(_ state: NSControl.StateValue) -> Self {
        set(\.state, to: state)
    }

    /// Set the image associated with this menu item, no matter the state
    public func image(_ image: NSImage) -> Self {
        set(\.image, to: image)
    }

    /// Set the on/off/mixed-state-specific image
    public func image(_ image: NSImage, for state: NSControl.StateValue) -> Self {
        apply { item in
            switch state {
            case .off: item.offStateImage = image
            case .on: item.onStateImage = image
            case .mixed: item.mixedStateImage = image
            default: fatalError("Unsupported MenuItem state \(state)")
            }
        }
    }

    /// Indent the menu item to the given level
    public func indent(level: Int) -> Self {
        set(\.indentationLevel, to: level)
    }

    /// Set the tooltip displayed when hovering over the menu item
    public func toolTip(_ toolTip: String) -> Self {
        set(\.toolTip, to: toolTip)
    }

    #if canImport(SwiftUI)
    /// Display a custom SwiftUI view instead of the title or attributed title
    /// Note that the passed closure will only be called once.
    /// Any views inside a menu item can use the `menuItemIsHighlighted`
    /// environment value to alter its appearance when selected.
    @available(macOS 10.15, *)
    public func view<Content: View>(showsHighlight: Bool = true, @ViewBuilder _ content: @escaping () -> Content) -> Self {
        view(MenuItemView(showsHighlight: showsHighlight, content()))
    }
    #endif

    /// Dissplay a custom NSView instead of the title or attributed title
    public func view(_ view: NSView) -> Self {
        set(\.view, to: view)
    }
}
