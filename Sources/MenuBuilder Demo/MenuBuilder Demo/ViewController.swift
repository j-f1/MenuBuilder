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
            MenuItem("About") {
                MenuItem("Version 1.2.3")
                MenuItem("Copyright 2021")
            }
            MenuItem("Quit")
                .shortcut("q")
                .onSelect { NSApp.terminate(nil) }
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
            Text("Value: \(Int(value))").font(Font.body.monospacedDigit())
        }
        .padding(.horizontal)
        .frame(minWidth: 250)
    }
}

