# MenuBuilder

A function builder for `NSMenu`s, similar in spirit to SwiftUI’s `ViewBuilder`.

Usage example (see demo for more details):

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

Note that there is no way to preserve the existing menu items, although it should be possible to implement that — feel free to open an issue or PR adding update support if you want it!


## Contributing

Open the `MenuBuilder.xcworkspace` to view the package and demo at the same time. PRs and issues are appreciated!
