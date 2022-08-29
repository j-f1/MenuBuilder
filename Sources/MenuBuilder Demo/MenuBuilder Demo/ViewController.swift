//
//  ViewController.swift
//  MenuBuilder Demo
//
//  Created by Jed Fox on 12/31/20.
//

import Cocoa
import MenuBuilder
import SwiftUI

class ViewController: NSViewController {

    var demoMenu: NSMenu!
    
    @objc
    private func printSenderTag(_ sender: NSMenuItem) {
        print("tag:", sender.tag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        demoMenu = NSMenu {
            MenuItem("Click me")
                .onSelect { print("clicked!") }
            MenuItem("Item with a view")
                .view(showsHighlight: false) {
                    MyMenuItemView()
                }
            SeparatorItem()
            MenuItem("Show About Panel")
                .action(#selector(NSApplication.orderFrontStandardAboutPanel(_:)))
            MenuItem("Item with tag")
                .tag(42)
                .onSelect(target: self, action: #selector(printSenderTag(_:)))
            MenuItem("About")
                .submenu {
                    MenuItem("Version 1.2.3")
                    MenuItem("Copyright 2021")
                }
            MenuItem("Quit")
                .shortcut("q")
                .onSelect { NSApp.terminate(nil) }
            // Uncomment once Xcode 12.5 becomes available
            // for word in ["Hello", "World"] {
            //     MenuItem(word)
            // }
        }
    }

    @IBAction func onClick(_ sender: NSButton) {
        demoMenu.popUp(
            positioning: nil,
            at: .init(x: sender.bounds.minX, y: sender.bounds.maxY),
            in: sender)
    }
}

struct MyMenuItemView: View {
    @State var value = 5.0
    var body: some View {
        HStack {
            Slider(value: $value, in: 0...9, step: 1)
            Text("Value: \(value)").font(Font.body.monospacedDigit())
        }
        .padding(.horizontal)
        .frame(minWidth: 250)
    }
}

