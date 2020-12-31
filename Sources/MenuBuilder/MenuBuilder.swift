import Cocoa

@_functionBuilder
public struct MenuBuilder {
    static func buildBlock(_ items: [NSMenuItem]...) -> [NSMenuItem] {
        items.flatMap { $0 }
    }

    static func buildExpression(_ expr: NSMenuItem?) -> [NSMenuItem] {
        if let item = expr {
            return [item]
        }
        return []
    }

    static func buildExpression(_ expr: MenuEntry?) -> [NSMenuItem] {
        if let item = expr?.nativeItem {
            return [item]
        }
        return []
    }

    static func buildOptional(_ item: [NSMenuItem]?) -> [NSMenuItem] {
        item ?? []
    }
}

extension NSMenu {
    convenience init(@MenuBuilder _ items: () -> [NSMenuItem]) {
        self.init()
        self.items = items()
    }
}
