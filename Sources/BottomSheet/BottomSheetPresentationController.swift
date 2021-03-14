#if canImport(UIKit)
import UIKit

/// An object that manages the transition animations and the presentation of `BottomSheetViewController`.
public final class BottomSheetPresentationController: UIPresentationController {
  
  /// The center of the presented view. Used to restore the original position of the bottom sheet after dragging without dismiss.
  private var presentedViewCenter: CGPoint = .zero
  
  // MARK: - Computed Properties
  
  /// The frame of the presented view according to the bottom sheet sizing style.
  public override var frameOfPresentedViewInContainerView: CGRect {
    switch sheetSizingStyle {
      case .adaptive: return adaptiveFrame
      case .toSafeAreaTop: return toSafeAreaTopFrame
      case .fixed(let height): return fixedFrame(height)
    }
  }
  
  /// The frame for the `adaptive` sheet sizing style.
  private var adaptiveFrame: CGRect {
    guard let containerView = containerView, let presentedView = presentedView else { return .zero }
    
    let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
    
    let targetWidth = safeAreaFrame.width
    // Fitting size for auto layout
    let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
    var targetHeight = presentedView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height
    
    // Handle cases when the containerView does not use auto layout
    if let tableView = presentedView.subviews.first(where: { $0 is UITableView }) as? UITableView {
      targetHeight += tableView.contentSize.height
    }
    if let tableView = presentedView as? UITableView {
      targetHeight += tableView.contentSize.height
    }
    if let collectionView = presentedView.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView {
      targetHeight += collectionView.contentSize.height
    }
    if let collectionView = presentedView as? UICollectionView {
      targetHeight += collectionView.contentSize.height
    }
    
    // Add the bottom safe area inset
    targetHeight += containerView.safeAreaInsets.bottom
    
    var frame = safeAreaFrame
    frame.origin.y += frame.size.height - targetHeight
    frame.size.width = targetWidth
    frame.size.height = targetHeight
    
    if frame.height > toSafeAreaTopFrame.height {
      return toSafeAreaTopFrame
    }
    return frame
  }
  
  /// The frame for the `toSafeArea` sheet sizing style.
  private var toSafeAreaTopFrame: CGRect {
    guard let containerView = containerView else { return .zero }
    
    let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
    let targetWidth = safeAreaFrame.width
    
    var frame = safeAreaFrame
    frame.origin.y += containerView.safeAreaInsets.bottom
    frame.size.width = targetWidth
    return frame
  }
    
  /// The style of the bottom sheet
  var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
    guard let presentedController = presentedViewController as? BottomSheetViewController else { return .toSafeAreaTop }
    return presentedController.sheetSizingStyle
  }
  
  // MARK: - UI Elements
  
  /// The blur view showing as the background of the bottom sheet.
  private lazy var dimmingView: UIVisualEffectView = {
    let effect: UIBlurEffect
    
    if #available(iOS 13.0, *) {
      effect = UIBlurEffect(style: .systemUltraThinMaterial)
    } else {
      effect = UIBlurEffect(style: .regular)
    }
    
    let view = UIVisualEffectView(effect: effect)
    let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
    view.addGestureRecognizer(gesture)
    return view
  }()
  
  /// A pan gesture handling the dragging of the bottom sheet.
  private lazy var panGesture: UIPanGestureRecognizer = {
    UIPanGestureRecognizer(target: self, action: #selector(drag))
  }()
  
  // MARK: - Init
  
  /// Initializes and returns a presentation controller for transitioning between a presenting controller and a `BottomSheetViewController`.
  /// - Parameters:
  ///   - presentedViewController: The `BottomSheetViewController` being presented modally.
  ///   - presentingViewController: The view controller whose content represents the starting point of the transition.
  public init(presentedViewController: BottomSheetViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  // MARK: - Functions
  
  /// Calculates the frame of the view for the `fixed` sheet sizing style.
  /// - Parameter height: The desired height of the bottom sheet.
  /// - Returns: A `CGRect` describing the frame of the bottom sheet.
  private func fixedFrame(_ height: CGFloat) -> CGRect {
    guard let containerView = containerView else { return .zero }
    
    let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
    let targetWidth = safeAreaFrame.width
    
    var frame = safeAreaFrame
    frame.origin.y += containerView.safeAreaInsets.bottom
    frame.size.width = targetWidth
    frame.size.height = height
    
    if frame.height > toSafeAreaTopFrame.height {
      return toSafeAreaTopFrame
    }
    return frame
  }
  
  public override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    guard let presentedView = presentedView else { return }
    
    presentedView.isUserInteractionEnabled = true
    
    if !(presentedView.gestureRecognizers?.contains(panGesture) ?? false) {
      presentedView.addGestureRecognizer(panGesture)
    }
  }
  
  public override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    
    guard let presenterView = containerView else { return }
    guard let presentedView = presentedView else { return }
    
    presentedView.frame = frameOfPresentedViewInContainerView
    
    let gap = presenterView.bounds.height - frameOfPresentedViewInContainerView.height
    presentedView.center = CGPoint(x: presenterView.center.x, y: presenterView.center.y + gap / 2)
    presentedViewCenter = presentedView.center
    
    dimmingView.frame = presenterView.bounds
  }
  
  public override func presentationTransitionWillBegin() {
    dimmingView.alpha = 0
    
    guard let presenterView = containerView else { return }
    presenterView.addSubview(dimmingView)
    
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
      self?.dimmingView.alpha = 1
    }, completion: nil)
  }
  
  public override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
      self?.dimmingView.alpha = 0
    }, completion: { [weak self] context in
      self?.dimmingView.removeFromSuperview()
    })
  }
  
  /// Dismisses the view controller.
  @objc private func dismiss() {
    presentedViewController.dismiss(animated: true, completion: nil)
  }
  
  /// Handles the drag gesture on the bottom sheet.
  /// This action moves the frame of the bottom sheet following the user's finger.
  /// Dragging the view after a certain threshold will dismiss it.
  ///
  /// - Parameters:
  ///   - gesture: The `UIPanGestureRecognizer` on the bottom sheet.
  @objc private func drag(_ gesture: UIPanGestureRecognizer) {
    guard let presentedView = presentedView, let presenterView = containerView else { return }
    
    defer {
      gesture.setTranslation(.zero, in: presentingViewController.view)
    }
    
    if case .changed = gesture.state {
      presentingViewController.view.bringSubviewToFront(presentedView)
      let translation = gesture.translation(in: presentingViewController.view)
      let y = presentedView.center.y + translation.y
      
      let gap = presenterView.bounds.height - presentedView.frame.height
      
      let shouldBounce = y - gap / 2 > presentingViewController.view.center.y
      
      if shouldBounce {
        presentedView.center = CGPoint(x: presentedView.center.x, y: y)
      }
      
      return
    }
    
    if case .ended = gesture.state {
      let height = presentingViewController.view.frame.height
      let position = presentedView.convert(presentingViewController.view.frame, to: nil).origin.y
      
      let velocity = gesture.velocity(in: presentedView)
      let targetVelocityHeight = presentedView.frame.height * 2
      let targetDragHeight = presentedView.frame.height * 3 / 4
      
      if velocity.y > targetVelocityHeight || height - position < targetDragHeight {
        dismiss()
      } else {
        restorePosition()
        restoreDimming()
      }
      
      return
    }
  }
  
  /// Restores the bottom sheet to its original position. Used when the user is dragging but not enough to dismiss the bottom sheet.
  private func restorePosition() {
    guard let presentedView = presentedView else { return }
    
    UIView.animate(withDuration: 0.25) { [self] in
      presentedView.center = presentedViewCenter
    }
  }
  
  /// Restores the opacity of the dimming background view. Used when the user is dragging but not enough to dismiss the bottom sheet.
  private func restoreDimming() {
    UIView.animate(withDuration: 0.25) { [self] in
      dimmingView.alpha = 1.0
    }
  }
}
#endif
