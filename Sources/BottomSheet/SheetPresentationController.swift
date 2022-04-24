import UIKit

/// An object that manages the presentation of a controller with a bottom sheet appearance.
final class SheetPresentationController: UIPresentationController {
  
  // MARK: - Constants
  
  /// The corner radius of the sheet.
  private let cornerRadius: CGFloat = 24
  
  /// The percentage to trigger the dismiss transition.
  private let dismissThreshold: CGFloat = 0.3
  
  // MARK: - Computed Properties
  
  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = containerView, let presentedView = presentedView else {
      return super.frameOfPresentedViewInContainerView
    }
    
    /// The maximum height allowed for the sheet. We allow the sheet to reach the top safe area inset.
    let maximumHeight = containerView.frame.height - containerView.safeAreaInsets.top - containerView.safeAreaInsets.bottom
    
    let fittingSize = CGSize(width: containerView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
    let presentedViewHeight = presentedView.systemLayoutSizeFitting(
      fittingSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .defaultLow
    ).height
    
    /// The target height of the presented view.
    /// If the size of the of the presented view could not be computed, meaning its equal to zero, we default to the maximum height.
    let targetHeight = presentedViewHeight == .zero ? maximumHeight : presentedViewHeight
    
    // Adjust the height of the view by adding the bottom safe area inset.
    let adjustedHeight = min(targetHeight, maximumHeight) + containerView.safeAreaInsets.bottom
    
    let targetSize = CGSize(width: containerView.frame.width, height: adjustedHeight)
    let targetOrigin = CGPoint(x: .zero, y: containerView.frame.maxY - targetSize.height)
    
    return CGRect(origin: targetOrigin, size: targetSize)
  }
  
  /// The `UIScrollView` embedded in the `presentedView`.
  /// When available, the drag of the scroll view will be used to drive the interactive dismiss transition.
  private var presentedScrollView: UIScrollView? {
    guard let presentedView = presentedView else {
      return nil
    }
        
    if let scrollView = presentedView.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
      return scrollView
    }
    
    return nil
  }
  
  /// The object that is managing the presentation and transition.
  private var transitioningDelegate: SheetTransitioningDelegate? {
    presentedViewController.transitioningDelegate as? SheetTransitioningDelegate
  }
  
  // MARK: - UI Elements
  
  private lazy var visualEffect: UIBlurEffect = {
    if #available(iOS 13.0, *) {
      return UIBlurEffect(style: .systemUltraThinMaterial)
    } else {
      return UIBlurEffect(style: .regular)
    }
  }()
  
  /// The view displayed behind the presented controller.
  private lazy var backgroundView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: nil)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedBackgroundView)))
    return view
  }()
  
  /// The view displaying a handle on the presented view.
  private let handleView: UIView = {
    let view = UIView()
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemFill
    } else {
      view.backgroundColor = .lightGray
    }
    view.frame.size = CGSize(width: 40, height: 4)
    return view
  }()
  
  /// The pan gesture used to drag and interactively dismiss the sheet.
  private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedPresentedView))
  
  // MARK: - Methods
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    containerView?.addSubview(backgroundView)
    
    presentedView?.addSubview(handleView)
        
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
      guard let self = self else {
        return
      }
      
      self.presentedView?.layer.cornerRadius = self.cornerRadius
      self.backgroundView.effect = self.visualEffect
    })
  }
  
  override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    
    layoutAccessoryViews()
    
    guard let presentedView = presentedView else {
      return
    }
    
    setupPresentedViewInteraction()
    
    if #available(iOS 13.0, *) {
      presentedView.layer.cornerCurve = .continuous
    }
    presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    presentedViewController.additionalSafeAreaInsets.top = handleView.frame.maxY
  }
  
  override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()
    
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
      guard let self = self else {
        return
      }
      
      self.presentedView?.layer.cornerRadius = .zero
      self.backgroundView.effect = nil
    })
  }
    
  // MARK: - Private Helpers

  /// Lays out the accessory views of the presentation.
  private func layoutAccessoryViews() {
    guard let containerView = containerView else {
      return
    }
    
    backgroundView.frame = containerView.bounds
    
    guard let presentedView = presentedView else {
      return
    }
    
    handleView.frame.origin.y = 8
    handleView.center.x = presentedView.center.x
    
    handleView.layer.cornerRadius = handleView.frame.height / 2
  }
  
  /// Sets up the interaction on the `presentedView`.
  ///
  /// If the view embeds a `UIScrollView` we will ask the presented view to lay out its contents, then ask for the scroll view's content size.
  /// If the content size is bigger than the frame of the scroll view, then we use the drag of the scroll as driver for the dismiss interaction.
  /// Otherwise we just add the pan gesture recognizer to the presented view.
  private func setupPresentedViewInteraction() {
    guard let presentedView = presentedView else {
      return
    }
    
    guard let presentedScrollView = presentedScrollView else {
      presentedView.addGestureRecognizer(panGesture)
      return
    }
    
    presentedView.layoutIfNeeded()
    
    if presentedScrollView.contentSize.height > presentedScrollView.frame.height {
      presentedScrollView.delegate = self
    } else {
      presentedView.addGestureRecognizer(panGesture)
    }
  }

  /// Triggers the dismiss transition in an interactive manner.
  /// - Parameter isInteractive: Whether the transition should be started interactively by the user.
  private func dismiss(interactively isInteractive: Bool) {
    transitioningDelegate?.transition.isPresenting = false
    transitioningDelegate?.transition.wantsInteractiveStart = isInteractive
    presentedViewController.dismiss(animated: true)
  }
  
  /// Updates the progress of the dismiss transition.
  /// - Parameter translation: The translation of the presented view used to calculate the progress.
  private func updateTransitionProgress(for translation: CGPoint) {
    guard let transitioningDelegate = transitioningDelegate else {
      return
    }
    
    guard let presentedView = presentedView else {
      return
    }

    let adjustedHeight = presentedView.frame.height - translation.y
    let progress = 1 - (adjustedHeight / presentedView.frame.height)
    transitioningDelegate.transition.update(progress)
  }
  
  /// Handles the ended interaction, either a drag or scroll, on the presented view.
  private func handleEndedInteraction() {
    guard let transitioningDelegate = transitioningDelegate else {
      return
    }

    if transitioningDelegate.transition.dismissFractionComplete > dismissThreshold {
      transitioningDelegate.transition.finish()
    } else {
      transitioningDelegate.transition.cancel()
    }
  }

  @objc
  private func tappedBackgroundView() {
    dismiss(interactively: false)
  }
  
  @objc
  private func pannedPresentedView(_ recognizer: UIPanGestureRecognizer) {
    guard let presentedView = presentedView, let containerView = containerView else {
      return
    }
    
    switch recognizer.state {
    case .began:
      dismiss(interactively: true)
      
    case .changed:
      guard presentedView.frame.maxY >= containerView.frame.maxY else {
        return
      }

      let translation = recognizer.translation(in: presentedView)
      updateTransitionProgress(for: translation)
            
    case .ended, .cancelled, .failed:
      handleEndedInteraction()
      
    // swiftlint:disable:next unnecessary_case_break
    case .possible:
      break
      
    @unknown default:
      break
    }
  }
}

extension SheetPresentationController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    guard scrollView.contentOffset.y <= .zero else {
      return
    }
    
    dismiss(interactively: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let presentedView = presentedView else {
      return
    }
    
    if scrollView.contentOffset.y < .zero {
      let originalOffset = CGPoint(x: scrollView.contentOffset.x, y: -scrollView.safeAreaInsets.top)
      scrollView.setContentOffset(originalOffset, animated: false)
    }
    
    let translation = scrollView.panGestureRecognizer.translation(in: presentedView)
    updateTransitionProgress(for: translation)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    handleEndedInteraction()
  }
}
