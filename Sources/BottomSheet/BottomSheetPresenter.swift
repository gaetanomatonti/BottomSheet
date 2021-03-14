#if canImport(UIKit)
public protocol BottomSheetPresenter: AnyObject {
  var bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate { get }
}
#endif
