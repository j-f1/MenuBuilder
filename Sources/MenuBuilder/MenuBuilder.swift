import Cocoa

/// A function builder type that produces an array of `NSMenuItem`s
@resultBuilder
public struct MenuBuilder {
    public static func buildBlock(_ block: [NSMenuItem]...) -> [NSMenuItem] {
        block.flatMap { $0 }
    }

    public static func buildOptional(_ item: [NSMenuItem]?) -> [NSMenuItem] {
        item ?? []
    }

    public static func buildEither(first: [NSMenuItem]?) -> [NSMenuItem] {
        first ?? []
    }
    public static func buildEither(second: [NSMenuItem]?) -> [NSMenuItem] {
        second ?? []
    }

    public static func buildArray(_ components: [[NSMenuItem]]) -> [NSMenuItem] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expr: [NSMenuItem]?) -> [NSMenuItem] {
        expr ?? []
    }

    public static func buildExpression(_ expr: NSMenuItem?) -> [NSMenuItem] {
        expr.map { [$0] } ?? []
    }
}

extension NSMenu {
    /// Create a new menu with the given items
    public convenience init(@MenuBuilder _ items: () -> [NSMenuItem]) {
        self.init()
        self.replaceItems(with: items)
    }

    public func replaceItems(@MenuBuilder with items: () -> [NSMenuItem]) {
        self.items = items()
    }
}
