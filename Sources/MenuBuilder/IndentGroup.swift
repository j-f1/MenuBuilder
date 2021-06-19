//
//  IndentGroup.swift
//  
//
//  Created by Jed Fox on 6/19/21.
//

import Cocoa

public struct IndentGroup {
    fileprivate let children: () -> [NSMenuItem?]

    public init(@MenuBuilder children: @escaping () -> [NSMenuItem?]) {
        self.children = children
    }
}

extension MenuBuilder {
    public static func buildExpression(_ expr: IndentGroup?) -> [NSMenuItem] {
        if let items = expr?.children().compactMap({ $0 }) {
            for item in items {
                item.indentationLevel += 1
            }
            return items
        }
        return []
    }
}
