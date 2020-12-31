import Cocoa
import SwiftUI

public struct MenuItem {
    let createItem: () -> NSMenuItem
    let mutators: [(NSMenuItem) -> ()]

    private func withMutations(_ mutator: @escaping (NSMenuItem) -> ()) -> Self {
        Self(createItem: createItem, mutators: mutators + [mutator])
    }

    internal init(createItem: @escaping () -> NSMenuItem, mutators: [(NSMenuItem) -> ()]) {
        self.createItem = createItem
        self.mutators = mutators
    }

    public init(_ title: String) {
        createItem = { NSMenuItem(title: title, action: nil, keyEquivalent: "") }
        mutators = []
    }

    public init(_ title: NSAttributedString) {
        createItem = { NSMenuItem(title: title.string, action: nil, keyEquivalent: "") }
        mutators = [{ item in
            item.attributedTitle = title
        }]
    }
}

extension MenuItem: MenuEntry {
    var nativeItem: NSMenuItem {
        let item = createItem()
        mutators.forEach { $0(item) }
        return item
    }
}

extension MenuItem {
    init(_ title: String, @MenuBuilder children: @escaping () -> [NSMenuItem]) {
        createItem = { NSMenuItem(title: title, action: nil, keyEquivalent: "") }
        mutators = [{ item in
            item.submenu = NSMenu(title: title)
            item.submenu!.items = children()
        }]
    }
}

extension MenuItem {
    public func shortcut(_ shortcut: String, holding modifiers: NSEvent.ModifierFlags? = nil) -> Self {
        withMutations { item in
            item.keyEquivalent = shortcut
            if let modifiers = modifiers {
                item.keyEquivalentModifierMask = modifiers
            }
        }
    }

    public func onSelect(_ handler: @escaping () -> ()) -> Self {
        withMutations { item in
            item.representedObject = handler
            item.target = MenuInvoker.shared
            item.action = #selector(MenuInvoker.run(_:))
        }
    }

    public func disabled(_ disabled: Bool = true) -> Self {
        withMutations { $0.isEnabled = !disabled }
    }

    public func state(_ state: NSControl.StateValue) -> Self {
        withMutations { $0.state = state }
    }

    public func image(_ image: NSImage) -> Self {
        withMutations { $0.image = image }
    }

    public func image(_ image: NSImage, for state: NSControl.StateValue) -> Self {
        withMutations { item in
            switch state {
            case .off: item.offStateImage = image
            case .on: item.onStateImage = image
            case .mixed: item.mixedStateImage = image
            default: fatalError("Unsupported MenuItem state \(state)")
            }
        }
    }

    public func indent(level: Int) -> Self {
        withMutations { $0.indentationLevel = level }
    }

    public func toolTip(_ toolTip: String) -> Self {
        withMutations { $0.toolTip = toolTip }
    }

    public func view<Content: View>(@ViewBuilder _ content: @escaping () -> Content) -> Self {
        withMutations {
            $0.view = MenuItemView(content())
        }
    }
}
