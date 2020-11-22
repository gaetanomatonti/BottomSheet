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
        
        mainView.button.addAction(UIAction(handler: didPressButton), for: .touchUpInside)
        mainView.sheetSizingStylePicker.addAction(UIAction(handler: didSelectSegmentedItem), for: .valueChanged)
        mainView.handleStylePicker.addAction(UIAction(handler: didSelectSegmentedItem), for: .valueChanged)
    }
    
    private func didPressButton(_ action: UIAction) {
        let controller = BottomSheetViewController()
        controller.contentView = ExampleBottomSheetView()
        controller.sheetCornerRadius = 32
        controller.sheetSizingStyle = viewModel.selectedSheetSizingStyle
        controller.handleStyle = viewModel.selectedHandleStyle
        controller.contentInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        present(controller, animated: true, completion: nil)
    }
    
    func didSelectSegmentedItem(_ action: UIAction) {
        guard let sender = action.sender as? UISegmentedControl else { return }
        
        switch sender {
            case mainView.sheetSizingStylePicker:
                viewModel.selectedSheetSizingStyle = viewModel.sheetSizingItems[mainView.sheetSizingStylePicker.selectedSegmentIndex].style
            case mainView.handleStylePicker:
                viewModel.selectedHandleStyle = viewModel.handleStyleItems[mainView.handleStylePicker.selectedSegmentIndex].style
            default:
                break
        }
    }
    
}
