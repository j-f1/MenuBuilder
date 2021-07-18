import Cocoa
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Modifiers used to customize a ``MenuItem`` or ``CustomMenuItem``.
public protocol AnyMenuItem {
    associatedtype Item: NSMenuItem
    func apply(_ modifier: @escaping (Item) -> ()) -> Self
}

extension AnyMenuItem {
    // MARK: Behavior

    /// Runs a closure when the menu item is selected.
    public func onSelect(_ handler: @escaping () -> ()) -> Self {
        apply {
            $0.representedObject = handler
            $0.target = MenuInvoker.shared
            $0.action = #selector(MenuInvoker.run(_:))
        }
    }

    /// Sets the keyboard shortcut/key equivalent.
    public func shortcut(_ shortcut: String, holding modifiers: NSEvent.ModifierFlags = .command) -> Self {
        apply {
            $0.keyEquivalent = shortcut
            $0.keyEquivalentModifierMask = modifiers
        }
    }

    /// Disables the menu item.
    ///
    /// Menu items without a `onSelect` handler or submenu are always disabled.
    public func disabled(_ disabled: Bool = true) -> Self {
        set(\.isEnabled, to: !disabled)
    }

    /// Set the tooltip displayed when hovering over the menu item.
    public func toolTip(_ toolTip: String) -> Self {
        set(\.toolTip, to: toolTip)
    }

    // MARK: Appearance

    /// Sets the checked/unchecked/mixed state
    public func state(_ state: NSControl.StateValue) -> Self {
        set(\.state, to: state)
    }

    /// Display a custom `NSView` instead of the title or attributed title
    public func view(_ view: NSView) -> Self {
        set(\.view, to: view)
    }

#if canImport(SwiftUI)
    /// Display a custom SwiftUI `View` instead of the title or attributed title
    /// Note that the passed closure will only be called once.
    /// Any views inside a menu item can use the `menuItemIsHighlighted`
    /// environment value to alter its appearance when selected.
    @available(macOS 10.15, *)
    public func view<Content: View>(showsHighlight: Bool = true, @ViewBuilder _ content: @escaping () -> Content) -> Self {
        view(MenuItemView(showsHighlight: showsHighlight, content()))
    }
#endif

    /// Sets the image associated with this menu item
    public func image(_ image: NSImage) -> Self {
        set(\.image, to: image)
    }

    /// Sets an on/off/mixed-state-specific image
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

    // MARK: Advanced Customizations

    /// Indent the menu item to the given level
    public func indent(level: Int) -> Self {
        set(\.indentationLevel, to: level)
    }

    /// Set an arbitrary `keyPath` on the menu item to a value of your choice.
    ///
    /// Most of the other modifiers are just sugar wrapping this.
    public func set<Value>(_ keyPath: ReferenceWritableKeyPath<Item, Value>, to value: Value) -> Self {
        apply {
            $0[keyPath: keyPath] = value
        }
    }
}
