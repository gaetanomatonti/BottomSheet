import UIKit

/// An object that manages the presentation and transition of a bottom sheet.
///
/// To present a view controller with a bottom sheet appearance you should set the `modalPresentationStyle` of a view controller to `.custom`
/// and set its transitioning delegate to an instance of this class.
public final class SheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  
  // MARK: - Stored Properties
  
  /// The object the manages the transition animations.
  let transition = SheetTransition()
  
  // MARK: - Functions
  
  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    SheetPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = true
    transition.wantsInteractiveStart = false
    return transition
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = false
    return transition
  }
  
  public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    transition.isPresenting = false
    return transition
  }
}
