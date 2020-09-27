#if canImport(UIKit)
import UIKit

public final class BottomSheetView: UIView {
    /// The style of the sheet
    public enum SheetStyle {
        /// Adapts the size of the bottom sheet to its content. If the content height is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
        case adaptive
        /// Aligns the top of the bottom sheet to the top safe area inset.
        case toSafeAreaTop
        /// Sets a fixed height for the sheet. If `height` is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
        case fixed(height: CGFloat)
    }

    public enum HandleStyle: CaseIterable {
        /// Hides the handle
        case none
        /// Shows the handle inside the content view
        case inside
        /// Shows the handle on top of the content view
        case outside
    }
    
    public var handleStyle: HandleStyle = .none {
        willSet {
            setHandle(for: newValue)
            setNeedsDisplay()
        }
    }
    
    public var sheetStyle: SheetStyle
        
    /// Ancdhors the top of the `contentView` to its superview
    lazy var contentViewTopAnchor = makeContentViewTopConstraint()
    /// Anchors the top of `contentView` to the bottom of `dragHandle`. Used for `outside` handle style.
    lazy var contentViewTopToHandleAnchor = makeContentTopToHandleContraint()
    
    private lazy var dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = dragHandleColor
        view.layer.cornerRadius = 2
        return view
    }()
    
    /// The content of the bottom sheet. Assign your view to this variable to set a custom content.
    public var contentView: UIView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(contentView)
            
            updateContentTopConstraints()
            
            setHandle(for: handleStyle)
            setContentViewConstraints()
        }
    }
    
    func makeContentViewTopConstraint() -> NSLayoutConstraint {
        contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
    }
    
    func makeContentTopToHandleContraint() -> NSLayoutConstraint {
        contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: contentInsetFromHandle)
    }
    
    func updateContentTopConstraints() {
        // Update constraints for the new view
        contentViewTopAnchor = makeContentViewTopConstraint()
        contentViewTopToHandleAnchor = makeContentTopToHandleContraint()
    }
    
    /// The corner radius of the bottom sheet
    public var cornerRadius: CGFloat = 16 {
        willSet {
            setNeedsDisplay()
        }
    }
    
    public var handleInset: CGFloat = 12 {
        willSet {
            updateContentTopConstraints()
            setNeedsDisplay()
        }
    }
    
    public var contentInsetFromHandle: CGFloat = 16 {
        willSet {
            updateContentTopConstraints()
            setNeedsLayout()
        }
    }
    
    /// The color of the handle
    public var dragHandleColor: UIColor = .systemFill {
        willSet {
            dragHandle.backgroundColor = newValue
        }
    }
    
    /// The background color of the content view
    public var contentBackgroundColor: UIColor = .systemBackground {
        willSet {
            setNeedsDisplay()
        }
    }

    public init(sheetStyle: SheetStyle = .toSafeAreaTop, handleStyle: HandleStyle = .none) {
        self.sheetStyle = sheetStyle
        self.handleStyle = handleStyle
        super.init(frame: .zero)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
        setHandle(for: handleStyle)
    }
    
    override init(frame: CGRect) {
        self.sheetStyle = .toSafeAreaTop
        super.init(frame: frame)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
        
        setHandle(for: .none)
    }
    
    required init?(coder: NSCoder) {
        self.sheetStyle = .toSafeAreaTop
        super.init(coder: coder)

        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
        setHandle(for: .none)
    }
    
    public override func draw(_ rect: CGRect) {
        let handleHeight: CGFloat = handleStyle == .none ? 0 : dragHandle.frame.height
        let topInset: CGFloat = handleStyle == .none ? 0 : handleHeight + contentInsetFromHandle
        
        let outsideHandleInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let rect = handleStyle == .outside ? rect.inset(by: outsideHandleInsets) : rect
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        contentBackgroundColor.setFill()
        path.fill()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
        
    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setHandle(for style: HandleStyle) {
        switch style {
            case .none:
                dragHandle.removeFromSuperview()
                contentViewTopAnchor.isActive = true
            case .inside, .outside:
                addSubview(dragHandle)
                contentViewTopAnchor.isActive = style == .inside
                contentViewTopToHandleAnchor.isActive = style == .outside
                
                dragHandle.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    dragHandle.topAnchor.constraint(equalTo: topAnchor, constant: style == .inside ? handleInset : 0),
                    dragHandle.centerXAnchor.constraint(equalTo: centerXAnchor),
                    dragHandle.widthAnchor.constraint(equalToConstant: 40),
                    dragHandle.heightAnchor.constraint(equalToConstant: 4)
                ])
        }
        
        setNeedsDisplay()
    }
    
}

#endif

#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI

struct BottomSheetViewRepresentable: UIViewRepresentable {
    typealias UIViewType = BottomSheetView
    
    var handleStyle: BottomSheetView.HandleStyle
    
    func makeUIView(context: Context) -> BottomSheetView {
        let view = BottomSheetView(handleStyle: handleStyle)
        view.contentBackgroundColor = .systemGroupedBackground
        view.cornerRadius = 32
        return view
    }
    
    func updateUIView(_ uiView: BottomSheetView, context: Context) {
        uiView.handleStyle = handleStyle
    }
}

struct BottomSheetViewPreview: PreviewProvider {
    static var previews: some View {
        ForEach(BottomSheetView.HandleStyle.allCases, id: \.self) { style in
            BottomSheetViewRepresentable(handleStyle: style)
                .previewLayout(.fixed(width: 375, height: 460))
        }
    }
}
#endif
