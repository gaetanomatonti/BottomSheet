//
//  ExampleBottomSheetView.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit

final class ExampleBottomSheetView: UIView {
  
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
  
  // MARK: - SSUL
  
  private func setup() {
    addSubview(contentStack)
    setConstraints()
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
  
  // MARK: - Functions
  
  func setConstraints() {
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentStack.topAnchor.constraint(equalTo: topAnchor),
      contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
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
