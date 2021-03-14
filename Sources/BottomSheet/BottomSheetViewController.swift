#if canImport(UIKit)
import UIKit

public class BottomSheetViewController: UIViewController {
  
  private let bottomSheetView: BottomSheetView = {
    let view = BottomSheetView()
    view.accessibilityIdentifier = "BottomSheetContainer"
    return view
  }()
  
  public var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
    get { bottomSheetView.sheetSizingStyle }
    set { bottomSheetView.sheetSizingStyle = newValue }
  }
  
  public var handleStyle: BottomSheetView.HandleStyle {
    get { bottomSheetView.handleStyle }
    set { bottomSheetView.handleStyle = newValue }
  }
  
  public var handleColor: UIColor? {
    get { bottomSheetView.dragHandleColor }
    set { bottomSheetView.dragHandleColor = newValue }
  }
  
  public var contentView: UIView {
    get { bottomSheetView.contentView }
    set { bottomSheetView.contentView = newValue }
  }
  
  public var sheetCornerRadius: CGFloat {
    get { bottomSheetView.cornerRadius }
    set { bottomSheetView.cornerRadius = newValue }
  }
  
  public var contentInsets: UIEdgeInsets {
    get { bottomSheetView.contentInsets }
    set { bottomSheetView.contentInsets = newValue }
  }
  
  public init(handleStyle: BottomSheetView.HandleStyle = .none, cornerRadius: CGFloat = 16) {
    super.init(nibName: nil, bundle: nil)
    
    self.handleStyle = handleStyle
    self.sheetCornerRadius = cornerRadius
    
    commonInit()
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    commonInit()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    modalPresentationStyle = .custom
    transitioningDelegate = (UIApplication.shared.delegate as? BottomSheetPresenter)?.bottomSheetTransitioningDelegate
  }
  
  public override func loadView() {
    view = bottomSheetView
  }
}
#endif
