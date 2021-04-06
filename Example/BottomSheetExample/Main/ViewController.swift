//
//  ViewController.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit
import BottomSheet

final class ViewController: UIViewController {
  
  private let viewModel = ViewModel()
  private let mainView = View()
  
  override func loadView() {
    super.loadView()
    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.populateSegmentedControl(picker: \.sheetSizingStylePicker, with: viewModel.sheetSizingItems)
    
    mainView.button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    mainView.sheetSizingStylePicker.addTarget(self, action: #selector(didSelectSegmentedItem), for: .valueChanged)
    mainView.handleStylePicker.addTarget(self, action: #selector(didSelectSegmentedItem), for: .valueChanged)
  }
  
  @objc private func didPressButton(_ sender: UIButton) {
    let controller = UIViewController()
    let contentView = ExampleBottomSheetView()
    contentView.sheetSizingStyle = viewModel.selectedSheetSizingStyle
    controller.view = contentView
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate = (UIApplication.shared.delegate as? SheetPresenter)?.bottomSheetTransitioningDelegate
    present(controller, animated: true, completion: nil)
  }
  
  @objc func didSelectSegmentedItem(_ sender: UISegmentedControl) {
    if sender === mainView.sheetSizingStylePicker {
      viewModel.selectedSheetSizingStyle = viewModel.sheetSizingItems[mainView.sheetSizingStylePicker.selectedSegmentIndex].style
      return
    }
  }
}
