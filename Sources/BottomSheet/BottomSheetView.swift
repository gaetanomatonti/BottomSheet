#if canImport(UIKit)
import UIKit

public final class BottomSheetView: UIView {
    /// Defines a sizing style for the sheet
    public enum SheetSizingStyle {
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
            updateHandleConstraints(for: newValue)
            setNeedsDisplay()
        }
    }
    
    public var sheetSizingStyle: SheetSizingStyle
        
    /// Ancdhors the top of the `contentView` to its superview
    lazy var contentViewTopAnchor = makeContentViewTopConstraint()
    /// Anchors the top of `contentView` to the bottom of `dragHandle`. Used for `outside` handle style.
    lazy var contentViewTopToHandleAnchor = makeContentTopToHandleContraint()
    
    lazy var contentViewLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
    lazy var contentViewTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
    lazy var contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
    
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
            
            setHandle(for: handleStyle)
            setContentViewConstraints()
            updateHandleConstraints(for: handleStyle)
        }
    }
        
    /// The corner radius of the bottom sheet
    public var cornerRadius: CGFloat = 16 {
        willSet {
            setNeedsDisplay()
        }
    }
    
    public var handleInset: CGFloat = 12 {
        willSet {
            // Needs to redraw the sheet rectangle
            setNeedsDisplay()
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
    
    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            updateContentConstraints()
            setNeedsDisplay()
            setNeedsUpdateConstraints()
        }
    }
    
    private var bottomInset: CGFloat {
        safeAreaInsets.bottom + contentInsets.bottom
    }

    public init(sheetSizingStyle: SheetSizingStyle = .toSafeAreaTop, handleStyle: HandleStyle = .none) {
        self.sheetSizingStyle = sheetSizingStyle
        self.handleStyle = handleStyle
        super.init(frame: .zero)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
        setHandle(for: handleStyle)
        updateHandleConstraints(for: handleStyle)
    }
    
    override init(frame: CGRect) {
        self.sheetSizingStyle = .toSafeAreaTop
        super.init(frame: frame)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
        
        setHandle(for: .none)
        updateHandleConstraints(for: handleStyle)
    }
    
    required init?(coder: NSCoder) {
        self.sheetSizingStyle = .toSafeAreaTop
        super.init(coder: coder)

        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
        setHandle(for: .none)
        updateHandleConstraints(for: handleStyle)
    }
    
    var handleBottomInset: CGFloat {
        switch handleStyle {
            case .outside: return 12
            default: return 0
        }
    }
    
    public override func draw(_ rect: CGRect) {
        let handleHeight: CGFloat = handleStyle == .none ? 0 : dragHandle.frame.height
        let topInset: CGFloat = handleStyle == .none ? 0 : handleHeight + handleBottomInset
        
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
            
    public override func safeAreaInsetsDidChange() {
        // Need to change the bottom anchor constant because safe area layout guide gets disabled when the frame is moved
        if safeAreaInsets.bottom > -contentViewBottomAnchor.constant {
            contentViewBottomAnchor.constant = -bottomInset
            setNeedsUpdateConstraints()
        }
    }
    
    func makeContentViewTopConstraint() -> NSLayoutConstraint {
        contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: contentInsets.top)
    }
    
    func makeContentTopToHandleContraint() -> NSLayoutConstraint {
        contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: contentInsets.top + handleBottomInset)
    }
        
    private func updateContentConstraints() {
        contentViewTopAnchor.constant = contentInsets.top
        contentViewTopToHandleAnchor.constant = contentInsets.top + handleBottomInset
        contentViewLeadingAnchor.constant = contentInsets.left
        contentViewTrailingAnchor.constant = -contentInsets.right
        contentViewBottomAnchor.constant = -bottomInset
    }
    
    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentViewTopAnchor = contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top)
        contentViewTopToHandleAnchor = contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: contentInsets.top + handleBottomInset)
        contentViewLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
        contentViewTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
        contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset)

        NSLayoutConstraint.activate([
            contentViewLeadingAnchor,
            contentViewTrailingAnchor,
            contentViewBottomAnchor
        ])
    }
    
    private func setHandle(for style: HandleStyle) {
        switch style {
            case .none:
                dragHandle.removeFromSuperview()
            case .inside, .outside:
                addSubview(dragHandle)
                    
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
    
    private func updateHandleConstraints(for style: HandleStyle) {
        switch style {
            case .none:
                contentViewTopAnchor.isActive = true
            case .inside, .outside:
                contentViewTopAnchor.isActive = false
                contentViewTopToHandleAnchor.isActive = true
        }
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
