import Cocoa

/// A function builder type that produces an array of `NSMenuItem`s
@_functionBuilder
public struct MenuBuilder {
    public static func buildBlock(_ items: [NSMenuItem?]...) -> [NSMenuItem?] {
        items.flatMap { $0 }
    }

    public static func buildExpression(_ expr: NSMenuItem?) -> [NSMenuItem?] {
        [expr]
    }

    public static func buildOptional(_ item: [NSMenuItem?]?) -> [NSMenuItem?] {
        item ?? []
    }
}

extension NSMenu {
    /// Create a new menu with the given items
    public convenience init(@MenuBuilder _ items: () -> [NSMenuItem?]) {
        self.init()
        self.replaceItems(with: items)
    }

    public func replaceItems(@MenuBuilder with items: () -> [NSMenuItem?]) {
        self.items = items().compactMap { $0 }
    }
}
