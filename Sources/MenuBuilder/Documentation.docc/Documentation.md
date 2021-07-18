# ``MenuBuilder``

Swift Function Builder for creating `NSMenuItem`s


## Overview

A function builder for `NSMenu`s, similar in spirit to SwiftUI’s `ViewBuilder`.

Usage example (see “MenuBuilder Demo” for more details):

```swift
let menu = NSMenu {
  MenuItem("Click me")
    .onSelect { print("clicked!") } 
  MenuItem("Item with a view")
    .view {
      MyMenuItemView() // any SwiftUI view
    }
  SeparatorItem()
  MenuItem("About") {
    // rendered as disabled items in a submenu
    MenuItem("Version 1.2.3")
    MenuItem("Copyright 2021")
  }
  MenuItem("Quit")
    .shortcut("q")
    .onSelect { NSApp.terminate(nil) }
}

// later, to replace the menu items with different/updated ones:
menu.replaceItems {
  MenuItem("Replaced item").onSelect { print("Hello!") }
}
```

## Topics

### Creating Menu Items

- ``MenuItem``
- ``MenuItem/init(_:children:)``
- ``CustomMenuItem``
- ``AnyMenuItem``
- ``SeparatorItem``

### Constructing Menus

- ``IndentGroup``
- ``MenuBuilder/MenuBuilder``
