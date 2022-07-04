//
//  BottomSheetExample
//

import UIKit
import BottomSheet

final class ExampleBottomSheetView: UIView {
  
  // MARK: - UI Elements
  
  let titleLabel = UILabel()
  
  let descriptionLabel = UILabel()
  
  let button = UIButton(type: .system)
    
  // MARK: - Interactions
  
  var didTapButton: (() -> Void)?
  
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
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(button)
    
    let action = UIAction { [weak self] _ in
      self?.didTapButton?()
    }
    button.addAction(action, for: .touchUpInside)
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
  
  private func layout() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
      titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
      titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24)
    ])
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
      descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24)
    ])
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
      button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
      button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
      button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24)
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
    label.font = .preferredFont(forTextStyle: .title1)
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
    if #available(iOS 15, *) {
      var configuration = UIButton.Configuration.borderedProminent()
      configuration.title = "Dismiss"
      configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
      configuration.baseBackgroundColor = .systemOrange
      configuration.cornerStyle = .medium
      button.configuration = configuration
    } else {
      button.backgroundColor = .systemOrange
      button.setTitle("Dismiss", for: .normal)
      button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
      button.setTitleColor(.white, for: .normal)
      button.titleEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
      button.layer.cornerRadius = 8
    }
  }
}
