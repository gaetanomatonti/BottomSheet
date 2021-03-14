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
    mainView.populateSegmentedControl(picker: \.handleStylePicker, with: viewModel.handleStyleItems)
    
    mainView.button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    mainView.sheetSizingStylePicker.addTarget(self, action: #selector(didSelectSegmentedItem), for: .valueChanged)
    mainView.handleStylePicker.addTarget(self, action: #selector(didSelectSegmentedItem), for: .valueChanged)
  }
  
  @objc private func didPressButton(_ sender: UIButton) {
    let controller = BottomSheetViewController()
    controller.contentView = ExampleBottomSheetView()
    controller.sheetCornerRadius = 32
    controller.sheetSizingStyle = viewModel.selectedSheetSizingStyle
    controller.handleStyle = viewModel.selectedHandleStyle
    controller.contentInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    present(controller, animated: true, completion: nil)
  }
  
  @objc func didSelectSegmentedItem(_ sender: UISegmentedControl) {
    if sender === mainView.sheetSizingStylePicker {
      viewModel.selectedSheetSizingStyle = viewModel.sheetSizingItems[mainView.sheetSizingStylePicker.selectedSegmentIndex].style
      return
    }
    if sender === mainView.handleStylePicker {
      viewModel.selectedHandleStyle = viewModel.handleStyleItems[mainView.handleStylePicker.selectedSegmentIndex].style
      return
    }
  }
}
