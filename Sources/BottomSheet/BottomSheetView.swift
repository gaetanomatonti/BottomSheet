#if canImport(UIKit)
import UIKit

/// A container view for user content.
public final class BottomSheetView: UIView {
  /// The style of the handle. Defaults to `none`.
  public var handleStyle: HandleStyle = .none {
    willSet {
      setHandle(for: newValue)
      updateHandleConstraints(for: newValue)
      setNeedsDisplay()
    }
  }
  
  /// The sizing style of the sheet.
  public var sheetSizingStyle: SheetSizingStyle
    
  /// The corner radius of the bottom sheet
  public var cornerRadius: CGFloat = 16 {
    willSet {
      layer.cornerRadius = newValue
    }
  }
  
  public var handleInset: CGFloat = 12 {
    willSet {
      // Needs to redraw the sheet rectangle
      setNeedsDisplay()
    }
  }
  
  /// The color of the handle
  public var dragHandleColor: UIColor? {
    didSet {
      style()
    }
  }
    
  /// The insets the content view should be inset by in its container.
  public var contentInsets: UIEdgeInsets = .zero {
    didSet {
      updateContentConstraints()
      setNeedsDisplay()
      setNeedsUpdateConstraints()
    }
  }
  
  // MARK: - Computed Properties
  
  /// The total bottom inset taking safe area into consideration.
  private var bottomInset: CGFloat {
    safeAreaInsets.bottom + contentInsets.bottom
  }
  
  /// The inset at the bottom of the handle.
  var handleBottomInset: CGFloat {
    switch handleStyle {
      case .outside: return 12
      default: return 0
    }
  }
  
  // MARK: - Anchors
  
  /// Anchors the top of the `contentView` to its superview
  lazy var contentViewTopAnchor: NSLayoutConstraint = {
    contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: contentInsets.top)
  }()
  
  /// Anchors the top of `contentView` to the bottom of `dragHandle`. Used for `outside` handle style.
  lazy var contentViewTopToHandleAnchor: NSLayoutConstraint = {
    contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: contentInsets.top + handleBottomInset)
  }()
  
  /// Anchors the leading of the `contentView` to the leading anchor of its superview.
  lazy var contentViewLeadingAnchor: NSLayoutConstraint = {
    contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
  }()
  
  /// Anchors the trailing of the `contentView` to the trailing anchor of its superview.
  lazy var contentViewTrailingAnchor: NSLayoutConstraint = {
    contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
  }()
  
  /// Anchors the bottom of the `contentView` to thebottom anchor of its superview.
  lazy var contentViewBottomAnchor: NSLayoutConstraint = {
    contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
  }()
  
  // MARK: - UI Elements
  
  /// The drag handle positioned on the top of the sheet.
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
      
      style()
      
      setHandle(for: handleStyle)
      setContentViewConstraints()
      updateHandleConstraints(for: handleStyle)
    }
  }
  
  // MARK: - Init
  
  /// Creates a bottom sheet container with the specified sizing and handle styles.
  /// Initializing the view directly is strongly discouraged as it doesn't implement the presenting behaviour. Use `BottomSheetViewController` instead.
  /// - Parameters:
  ///   - sheetSizingStyle: The sizing style of the bottom sheet. Defaults to `toSafeAreaTop`.
  ///   - handleStyle: The handle style of the bottom sheet. Defaults to `none`.
  public init(sheetSizingStyle: SheetSizingStyle = .toSafeAreaTop, handleStyle: HandleStyle = .none) {
    self.sheetSizingStyle = sheetSizingStyle
    self.handleStyle = handleStyle
    
    super.init(frame: .zero)
    
    setup()
    style()
  }
  
  public required init?(coder: NSCoder) {
    self.sheetSizingStyle = .toSafeAreaTop
    
    super.init(coder: coder)
    
    setup()
    style()
  }
      
  public override func draw(_ rect: CGRect) {
    let handleHeight: CGFloat = handleStyle == .none ? 0 : dragHandle.frame.height
    let topInset: CGFloat = handleStyle == .none ? 0 : handleHeight + handleBottomInset
    
    let outsideHandleInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    let rect = handleStyle == .outside ? rect.inset(by: outsideHandleInsets) : rect
    
    // `UIBezierPath` draws rounded rects using a continuous corner.
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: [.topLeft, .topRight],
      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
    )
    
    contentView.backgroundColor?.setFill()
    path.fill()
  }
  
  public override func safeAreaInsetsDidChange() {
    // Need to change the bottom anchor constant because safe area layout guide gets disabled when the frame is moved
    if safeAreaInsets.bottom > -contentViewBottomAnchor.constant {
      contentViewBottomAnchor.constant = -bottomInset
      setNeedsUpdateConstraints()
    }
  }
  
  // MARK: - SSUL

  private func setup() {
    addSubview(contentView)
    
    setContentViewConstraints()
    setHandle(for: handleStyle)
    updateHandleConstraints(for: handleStyle)
  }
  
  private func style() {
    BottomSheetView.styleBottomSheet(self)
    BottomSheetView.styleDragHandle(dragHandle, with: dragHandleColor)
  }
  
  // MARK: - Functions
    
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
  
  /// Updates the position of the handle according to the specified `HandleStyle`.
  /// - Parameter style: The style to apply on the handle.
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
  
  /// Updates the constraints of the handle according to the specified `HandleStyle`.
  /// - Parameter style: The style to apply on the handle.
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

public extension BottomSheetView {
  /// Describes all possible sizing styles for the sheet.
  enum SheetSizingStyle {
    /// Adapts the size of the bottom sheet to its content. If the content height is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
    case adaptive
    /// Aligns the top of the bottom sheet to the top safe area inset.
    case toSafeAreaTop
    /// Sets a fixed height for the sheet. If `height` is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
    case fixed(height: CGFloat)
  }
  
  /// Describes all possible styles for the handle.
  enum HandleStyle: CaseIterable {
    /// Hides the handle
    case none
    /// Shows the handle inside the content view
    case inside
    /// Shows the handle on top of the content view
    case outside
  }
}

// MARK: - Styling Functions

private extension BottomSheetView {
  static func styleBottomSheet(_ view: BottomSheetView) {
    view.backgroundColor = .clear
    view.setNeedsDisplay()
  }
  
  static func styleDragHandle(_ view: UIView, with color: UIColor?) {
    if #available(iOS 13.0, *) {
      view.backgroundColor = color ?? .systemFill
    } else {
      view.backgroundColor = color ?? .groupTableViewBackground
    }
  }
}

#endif
