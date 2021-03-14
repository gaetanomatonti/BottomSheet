#if canImport(UIKit)
import UIKit

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
