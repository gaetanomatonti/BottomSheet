#if canImport(UIKit)
import UIKit

/// A protocol describing an object responsible for bottom sheet presentation.
/// Adopt this protocol to implement custom bottom sheet presentation behaviour.
/// This protocol can be used app-wise, by conforming `AppDelegate`, or in each controller custom presentation behaviour is desired.
public protocol BottomSheetPresenter: AnyObject {
  /// The object that provides custom transition animator and custom presentation objects.
  var bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate { get }
}
#endif
