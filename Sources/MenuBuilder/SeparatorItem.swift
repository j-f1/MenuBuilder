import Cocoa

/// A separator item. No configuration is available.
public struct SeparatorItem {
    public init() {}
}

extension MenuBuilder {
    public static func buildExpression(_ expr: SeparatorItem?) -> [NSMenuItem?] {
        if expr != nil {
            return [.separator()]

        }
        return [nil]
    }
}

