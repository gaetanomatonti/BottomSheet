#if canImport(UIKit)
import UIKit

/// An object that manages the transition animations and the presentation of `BottomSheetViewController`.
public final class SheetPresentationController: UIPresentationController {
  
  // MARK: - Stored Properties
  
  /// The center of the presented view. Used to restore the original position of the bottom sheet after dragging without dismiss.
  private var presentedViewCenter: CGPoint = .zero
    
  // MARK: - Computed Properties
  
  private var sheetPresentableViewController: SheetPresentable? {
    presentedViewController as? SheetPresentable
  }
  
  private var sheetPresentableView: SheetPresentable? {
    presentedView as? SheetPresentable
  }
  
  private var sheetConfiguration: SheetConfiguration {
    return sheetPresentableViewController ?? sheetPresentableView ?? SheetPresentationController.defaultConfiguration
  }
  
  /// The frame of the presented view according to the bottom sheet sizing style.
  public override var frameOfPresentedViewInContainerView: CGRect {
    switch sheetConfiguration.sheetSizingStyle {
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
    
    let topInset = containerView.safeAreaInsets.top
    
    var frame = containerView.frame
    frame.origin.y += topInset
    frame.size.height -= topInset
    return frame
  }
  
  // MARK: - UI Elements
  
  /// A grabber element.
  private lazy var grabber: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = .tertiaryLabel
    } else {
      view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
    }
    view.frame.size = sheetConfiguration.grabberSize
    view.layer.cornerRadius = sheetConfiguration.grabberSize.height / 2
    return view
  }()
  
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
    
    if sheetConfiguration.wantsGrabber {
      grabber.center.x = presentedView.center.x
      grabber.frame.origin.y = sheetConfiguration.topGrabberInset
      
      let additionalSafeAreaTopInset = sheetConfiguration.topGrabberInset + grabber.frame.height + sheetConfiguration.bottomGrabberInset
      presentedViewController.additionalSafeAreaInsets.top = additionalSafeAreaTopInset
    }
      
    dimmingView.frame = presenterView.bounds
  }
  
  public override func presentationTransitionWillBegin() {
    presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    if sheetConfiguration.wantsGrabber {
      presentedView?.addSubview(grabber)
    }
    
    dimmingView.alpha = 0
    
    guard let presenterView = containerView else { return }
    presenterView.addSubview(dimmingView)
    
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
      guard let self = self else {
        return
      }
      
      self.dimmingView.alpha = 1
      self.presentedView?.layer.cornerRadius = self.sheetConfiguration.preferredCornerRadius
    }, completion: nil)
  }
  
  public override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
      guard let self = self else {
        return
      }
      
      self.dimmingView.alpha = 0
      self.presentedView?.layer.cornerRadius = self.sheetConfiguration.dismissCornerRadius
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

extension SheetPresentationController {
  struct SheetPresentationControllerConfiguration: SheetConfiguration {
    var sheetSizingStyle: SheetSizingStyle = .toSafeAreaTop
    
    var wantsGrabber: Bool { false }
    
    var grabberSize: CGSize { CGSize(width: 32, height: 4) }
    
    var topGrabberInset: CGFloat { 8 }
    
    var bottomGrabberInset: CGFloat { 8 }
    
    var preferredCornerRadius: CGFloat { 12 }
    
    var dismissCornerRadius: CGFloat { 12 }
  }
  
  static let defaultConfiguration = SheetPresentationControllerConfiguration(sheetSizingStyle: .toSafeAreaTop)
}

#endif
