#if canImport(UIKit)

import UIKit

/// A protocol describing an object that can be presented in the form of a sheet.
public typealias SheetPresentable = SheetConfiguration

public extension SheetPresentable {  
  var wantsGrabber: Bool { false }
  
  var grabberSize: CGSize { CGSize(width: 32, height: 4) }
  
  var topGrabberInset: CGFloat { 8 }
  
  var bottomGrabberInset: CGFloat { 8 }
  
  var preferredCornerRadius: CGFloat { 12 }
  
  var dismissCornerRadius: CGFloat { 12 }
}

/// A protocol describing a `UIView` that can be presented in the form of a sheet.
internal typealias SheetPresentableView = UIView & SheetPresentable

/// A protocol describing a `UIViewController` that can be presented in the form of a sheet.
internal typealias SheetPresentableViewController = UIViewController & SheetPresentable

#endif
