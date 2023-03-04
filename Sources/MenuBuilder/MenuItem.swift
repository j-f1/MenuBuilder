import Cocoa

/// A standard menu item.
///
/// See ``AnyMenuItem`` for a listing of supported modifiers.
public struct MenuItem: AnyMenuItem {
    public typealias Modifier = (NSMenuItem) -> ()
    /// An array of functions that configure the menu item instance
    /// These may be called to update an existing menu item.
    fileprivate let modifiers: [Modifier]

    public func apply(_ modifier: @escaping Modifier) -> Self {
        Self(modifiers: modifiers + [modifier])
    }
    private init(modifiers: [Modifier]) {
        self.modifiers = modifiers
    }

    /// Creates a menu item with the given title.
    ///
    /// When targeting macOS 12 or later, `MenuBuilder("some title")` will use
    /// this initializer for automatic localization support.
    @available(macOS 12, *)
    public init(
        _ s: String.LocalizationValue,
        table: String? = nil,
        bundle: Bundle? = nil,
        locale: Locale = .current,
        comment: StaticString? = nil
    ) {
        modifiers = [{ item in
            item.title = String(localized: s, table: table, bundle: bundle, locale: locale, comment: comment)
        }]
    }

    /// Creates a menu item with the given (non-localized) title.
    @_disfavoredOverload
    public init(_ title: String) {
        modifiers = [{ item in item.title = title }]
    }

    /// Creates a menu item with the given (non-localized) title.
    public init(verbatim title: String) {
        modifiers = [{ item in item.title = title }]
    }

    /// Creates a menu item with the given localized string key used as the title.
    public init(localized title: String, table: String? = nil, bundle: Bundle = .main) {
        modifiers = [{ item in item.title = bundle.localizedString(forKey: title, value: nil, table: table) }]
    }

    /// Creates a menu item with the given attributed title.
    public init(_ title: NSAttributedString) {
        modifiers = [{ item in
            item.title = title.string
            item.attributedTitle = title
        }]
    }

    /// Creates a menu item with the given attributed title.
    @available(macOS 12, *)
    @_disfavoredOverload
    public init(_ title: AttributedString) {
        modifiers = [{ item in
            item.title = title.description
            item.attributedTitle = NSAttributedString(title)
        }]
    }

    /// Creates a menu item with a submenu containing the provided children.
    ///
    /// > Important: This initializer is deprecated.
    /// > Instead, use ``AnyMenuItem/submenu(_:)`` to specify the submenu after initialization:
    /// >
    /// > ```swift
    /// > MenuItem(title).submenu { ... }
    /// > ```
    @available(*, deprecated, message: "Use .submenu(_:) instead")
    public init(_ title: String, @MenuBuilder children: @escaping () -> [NSMenuItem]) {
        self = MenuItem(title).submenu(children)
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
}
