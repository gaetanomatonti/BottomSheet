import UIKit

/// An object that manages the transition animations for a `SheetPresentationController`.
final class SheetTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
  
  // MARK: - Stored Properties
    
  /// Whether the transition is used for a presentation. `false` if the transition is for the dismissal.
  var isPresenting = true
  
  /// The interactive animator used for the dismiss transition.
  private var dismissAnimator: UIViewPropertyAnimator?
  
  /// The animator used for the presentation animation.
  private var presentationAnimator: UIViewPropertyAnimator?
  
  /// The duration of the transition animation.
  private let animationDuration: TimeInterval = 0.75
  
  // MARK: - Computed Properties
  
  /// The progress of the dismiss animation.
  var dismissFractionComplete: CGFloat {
    dismissAnimator?.fractionComplete ?? .zero
  }
  
  // MARK: - Functions
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    animationDuration
  }
  
  // This will get called when the transition is not interactive (i.e: presenting or dismissing the controller through the methods).
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    interruptibleAnimator(using: transitionContext).startAnimation()
  }
  
  // This will get called when the transition is interactive.
  func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    if isPresenting {
      return presentationAnimator ?? presentationInterruptibleAnimator(using: transitionContext)
    } else {
      return dismissAnimator ?? dismissInterruptibleAnimator(using: transitionContext)
    }
  }
  
  private func presentationInterruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    guard let toViewController = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else {
      return UIViewPropertyAnimator()
    }
    
    let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.9)
    presentationAnimator = animator
    
    toView.frame = transitionContext.finalFrame(for: toViewController)
    toView.frame.origin.y = transitionContext.containerView.frame.maxY
    
    transitionContext.containerView.addSubview(toView)
    
    animator.addAnimations {
      toView.frame = transitionContext.finalFrame(for: toViewController)
    }
    
    animator.addCompletion { position in
      if case .end = position {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        return
      }
      
      transitionContext.completeTransition(false)
    }
    
    animator.addCompletion { [weak self] _ in
      self?.presentationAnimator = nil
    }
    
    return animator
  }
  
  private func dismissInterruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    guard let fromView = transitionContext.view(forKey: .from) else {
      return UIViewPropertyAnimator()
    }
    
    let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.9)
    dismissAnimator = animator
    
    animator.addAnimations {
      fromView.frame.origin.y = fromView.frame.maxY
    }
    
    animator.addCompletion { position in
      if case .end = position {
        fromView.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        return
      }
      
      transitionContext.completeTransition(false)
    }
    
    animator.addCompletion { [weak self] _ in
      self?.dismissAnimator = nil
    }
    
    return animator
  }
}
