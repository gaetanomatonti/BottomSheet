//
//  BottomSheetExample
//

import UIKit

final class View: UIView {
  
  // MARK: - UI Elements
    
  let presentSheetButton = UIButton()
    
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
    style()
    layout()
  }
  
  required init?(coder: NSCoder) {
    return nil
  }
  
  // MARK: - SSUL
  
  private func setup() {
    addSubview(presentSheetButton)
  }
  
  private func style() {
    Self.styleView(self)
    Self.stylePresentSheetButton(presentSheetButton)
  }
  
  private func layout() {
    presentSheetButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      presentSheetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      presentSheetButton.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}

// MARK: - Styling Functions

private extension View {
  static func styleView(_ view: View) {
    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemGroupedBackground
    } else {
      view.backgroundColor = .groupTableViewBackground
    }
  }
  
  static func stylePresentSheetButton(_ button: UIButton) {
    if #available(iOS 15.0, *) {
      var configuration = UIButton.Configuration.borderedTinted()
      configuration.title = "Present Sheet"
      button.configuration = configuration
    } else {
      button.setTitle("Present Sheet", for: .normal)
    }
  }
}
