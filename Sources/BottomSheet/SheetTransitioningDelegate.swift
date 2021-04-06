#if canImport(UIKit)
import UIKit

/// A transitioning delegate object providing custom transiton and presentation behaviour for `BottomSheetViewController`.
public final class SheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    return SheetPresentationController(presentedViewController: presented, presenting: presenting)
  }
}

#endif
