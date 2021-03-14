#if canImport(UIKit)
import UIKit

/// An object to control `BottomSheetView` customization and behaviour.
public final class BottomSheetViewController: UIViewController {
  
  /// The `BottomSheetView` containing user content.
  private let bottomSheetView: BottomSheetView = {
    let view = BottomSheetView()
    view.accessibilityIdentifier = "BottomSheetContainer"
    return view
  }()
  
  /// The sizing style of the sheet.
  public var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
    get { bottomSheetView.sheetSizingStyle }
    set { bottomSheetView.sheetSizingStyle = newValue }
  }
  
  /// The style of the handle. Defaults to `none`.
  public var handleStyle: BottomSheetView.HandleStyle {
    get { bottomSheetView.handleStyle }
    set { bottomSheetView.handleStyle = newValue }
  }
  
  /// The color of the handle.
  public var handleColor: UIColor? {
    get { bottomSheetView.dragHandleColor }
    set { bottomSheetView.dragHandleColor = newValue }
  }
  
  /// The content of the bottom sheet.
  public var contentView: UIView {
    get { bottomSheetView.contentView }
    set { bottomSheetView.contentView = newValue }
  }
  
  /// The corner radius of the bottom sheet.
  public var sheetCornerRadius: CGFloat {
    get { bottomSheetView.cornerRadius }
    set { bottomSheetView.cornerRadius = newValue }
  }
  
  /// The insets the content view should be inset by in its container.
  public var contentInsets: UIEdgeInsets {
    get { bottomSheetView.contentInsets }
    set { bottomSheetView.contentInsets = newValue }
  }
  
  // MARK: - Init
  
  /// Creates a `BottomSheetViewController` with the specified content view.
  /// - Parameter contentView: The content view to place into the bottom sheet.
  public convenience init(contentView: UIView) {
    self.init(nibName: nil, bundle: nil)
    
    self.contentView = contentView
    
    setup()
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    setup()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setup()
  }
  
  // MARK: - Lifecycle
  
  public override func loadView() {
    view = bottomSheetView
  }
  
  // MARK: - SSUL
  
  private func setup() {
    modalPresentationStyle = .custom
    transitioningDelegate = (UIApplication.shared.delegate as? BottomSheetPresenter)?.bottomSheetTransitioningDelegate
  }
}
#endif
