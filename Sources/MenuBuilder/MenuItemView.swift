#if canImport(SwiftUI)
import Cocoa
import SwiftUI

@available(macOS 10.15, *)
extension EnvironmentValues {
    private struct HighlightedKey: EnvironmentKey {
        static let defaultValue = false
    }

    /// Only updated inside of a `MenuItem(...).view { ... }` closure.
    /// Use this to adjust your content to look good in front of the selection background
    public var menuItemIsHighlighted: Bool {
        get {
            return self[HighlightedKey.self]
        }
        set {
            self[HighlightedKey.self] = newValue
        }
    }
}

/// A custom menu item view that manages highlight state and renders
/// an appropriate backdrop behind the view when highlighted
@available(macOS 10.15, *)
class MenuItemView<ContentView: View>: NSView {
    private var effectView: NSVisualEffectView
    let contentView: ContentView
    let hostView: NSHostingView<AnyView>
    let showsHighlight: Bool

    init(showsHighlight: Bool, _ view: ContentView) {
        effectView = NSVisualEffectView()
        contentView = view
        hostView = NSHostingView(rootView: AnyView(contentView))

        self.showsHighlight = showsHighlight

        super.init(frame: CGRect(origin: .zero, size: hostView.fittingSize))
        addSubview(effectView)
        addSubview(hostView)
        
        setUpEffectView()
        setUpConstraints()
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        let highlighted = enclosingMenuItem!.isHighlighted
        effectView.isHidden = !showsHighlight || !highlighted
        hostView.rootView = AnyView(contentView.environment(\.menuItemIsHighlighted, highlighted))
        super.draw(dirtyRect)
    }
    
    private func setUpEffectView() {
        effectView.state = .active
        effectView.material = .selection
        effectView.isEmphasized = true
        effectView.blendingMode = .behindWindow
        effectView.wantsLayer = true
        effectView.layer?.cornerRadius = 4
        effectView.layer?.cornerCurve = .continuous
    }
    
    private func setUpConstraints() {
        effectView.translatesAutoresizingMaskIntoConstraints = false
        hostView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 5
        effectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        effectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        effectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        effectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        
        hostView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        hostView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        hostView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        hostView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
#endif

