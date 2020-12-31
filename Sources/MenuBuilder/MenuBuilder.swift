import Cocoa

/// A function builder type that produces an array of `NSMenuItem`s
@_functionBuilder
public struct MenuBuilder {
    static func buildBlock(_ items: [NSMenuItem?]...) -> [NSMenuItem?] {
        items.flatMap { $0 }
    }

    static func buildExpression(_ expr: NSMenuItem?) -> [NSMenuItem?] {
        return [expr]
    }

    static func buildOptional(_ item: [NSMenuItem?]?) -> [NSMenuItem?] {
        item ?? []
    }
}

extension NSMenu {
    /// Create a new menu with the given items
    convenience init(@MenuBuilder _ items: () -> [NSMenuItem?]) {
        self.init()
        self.items = items().compactMap { $0 }
    }
}
