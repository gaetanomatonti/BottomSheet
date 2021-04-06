#if canImport(UIKit)

import UIKit

public protocol SheetConfiguration {
  /// The sizing style of the sheet.
  var sheetSizingStyle: SheetSizingStyle { get set }
  
  /// Whether to show a grabber on top of the sheet.
  var wantsGrabber: Bool { get }
  
  /// The size of the grabber UI element.
  var grabberSize: CGSize { get }
  
  /// The inset between the grabber and the top of the presented view.
  var topGrabberInset: CGFloat { get }
  
  /// The inset between the grabber and the content of the presented view.
  var bottomGrabberInset: CGFloat { get }
  
  /// The corner radius of the sheet when it's fully presented.
  /// Setting this to a value different from `dismissCornerRadius` animates the corner radius during the transition.
  var preferredCornerRadius: CGFloat { get }
  
  /// The corner radius of the sheet when it's dismissed.
  /// Setting this to a value different from `preferredCornerRadius` animates the corner radius during the transition.
  var dismissCornerRadius: CGFloat { get }
}

#endif
