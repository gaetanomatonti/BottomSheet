#if canImport(UIKit)

import UIKit

/// Describes all possible sizing styles for the sheet.
public enum SheetSizingStyle {
  /// Adapts the size of the bottom sheet to its content. If the content height is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
  case adaptive
  /// Aligns the top of the bottom sheet to the top safe area inset.
  case toSafeAreaTop
  /// Sets a fixed height for the sheet. If `height` is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
  case fixed(height: CGFloat)
}

#endif
