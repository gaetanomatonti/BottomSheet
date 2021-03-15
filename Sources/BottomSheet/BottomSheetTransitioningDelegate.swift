#if canImport(UIKit)
import UIKit

/// A transitioning delegate object providing custom transiton and presentation behaviour for `BottomSheetViewController`.
public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    guard let presentedController = presented as? BottomSheetViewController else { return nil }
    return BottomSheetPresentationController(
      presentedViewController: presentedController,
      presenting: presenting
    )
  }
}

#endif
