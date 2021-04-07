//
//  ExampleBottomSheetView.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit
import BottomSheet

final class ExampleBottomSheetView: UIView, SheetPresentable {
  
  var sheetSizingStyle: SheetSizingStyle = .adaptive
  
  var preferredCornerRadius: CGFloat { 32 }
  
  var wantsGrabber: Bool { true }
  
  // MARK: - UI Elements
  
  let titleLabel = UILabel()
  
  let descriptionLabel = UILabel()
  
  let button = UIButton(type: .system)
  
  lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, button])
    stack.axis = .vertical
    stack.spacing = 16
    stack.setCustomSpacing(24, after: descriptionLabel)
    return stack
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
    style()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setup()
    style()
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    NSLayoutConstraint.activate([
      contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      contentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
      contentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
      contentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24)
    ])
  }
  
  // MARK: - SSUL
  
  private func setup() {
    addSubview(contentStack)

    contentStack.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func style() {
    ExampleBottomSheetView.styleView(self)
    ExampleBottomSheetView.styleTitleLabel(
      titleLabel,
      with: "BottomSheet"
    )
    ExampleBottomSheetView.styleDescriptionLabel(
      descriptionLabel,
      with: "BottomSheet is a component made with UIKit and completely written in Swift\n🧡"
    )
    ExampleBottomSheetView.styleButton(button)
  }
}

// MARK: - Styling Functions

extension ExampleBottomSheetView {
  static func styleView(_ view: ExampleBottomSheetView) {
    if #available(iOS 13, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
  }
  
  static func styleTitleLabel(_ label: UILabel, with text: String?) {
    label.text = text
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  
  static func styleDescriptionLabel(_ label: UILabel, with text: String?) {
    label.text = text
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    label.textAlignment = .center
  }
  
  static func styleButton(_ button: UIButton) {
    button.backgroundColor = .systemOrange
    button.setTitle("Download", for: .normal)
    button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    button.setTitleColor(.white, for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    button.layer.cornerRadius = 8
  }
}
