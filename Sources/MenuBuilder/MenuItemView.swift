import Cocoa
import SwiftUI

extension EnvironmentValues {
    private struct HighlightedKey: EnvironmentKey {
        static let defaultValue = false
    }

    public var menuItemIsHighlighted: Bool {
        get {
            return self[HighlightedKey.self]
        }
        set {
            self[HighlightedKey.self] = newValue
        }
    }
}

class MenuItemView<ContentView: View>: NSView {
    private var effectView: NSVisualEffectView
    let contentView: ContentView
    let hostView: NSHostingView<AnyView>

    init(_ view: ContentView) {
        effectView = NSVisualEffectView()
        effectView.state = .active
        effectView.material = .selection
        effectView.isEmphasized = true
        effectView.blendingMode = .behindWindow

        contentView = view
        hostView = NSHostingView(rootView: AnyView(contentView))

        super.init(frame: CGRect(origin: .zero, size: hostView.intrinsicContentSize))
        addSubview(effectView)
        addSubview(hostView)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if window != nil {
            frame = NSRect(
                origin: frame.origin,
                size: CGSize(width: enclosingMenuItem!.menu!.size.width, height: frame.height)
            )
            effectView.frame = frame
            hostView.frame = frame
        }
    }
    override func draw(_ dirtyRect: NSRect) {
        let highlighted = enclosingMenuItem!.isHighlighted
        effectView.isHidden = !highlighted
        hostView.rootView = AnyView(contentView.environment(\.menuItemIsHighlighted, highlighted))
        super.draw(dirtyRect)
    }
}
