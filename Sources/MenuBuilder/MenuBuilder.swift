import Cocoa

/// A function builder type that produces an array of `NSMenuItem`s
@_functionBuilder
public struct MenuBuilder {
    public static func buildBlock(_ block: [NSMenuItem]...) -> [NSMenuItem] {
        block.flatMap { $0 }
    }

    public static func buildExpression(_ expr: [NSMenuItem]?) -> [NSMenuItem] {
        if let expr = expr {
            return expr
        }
        return []
    }

    public static func buildExpression(_ expr: NSMenuItem?) -> [NSMenuItem] {
        if let expr = expr {
            return [expr]
        }
        return []
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
