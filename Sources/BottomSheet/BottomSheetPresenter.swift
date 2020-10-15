#if canImport(UIKit)
public protocol BottomSheetPresenter: class {
    var bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate { get }
}
#endif
