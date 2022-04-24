//
//  BottomSheetExample
//

import UIKit
import BottomSheet

final class ViewController: UIViewController {
  
  // MARK: - Stored Properties
  
  private let sheetTransitioningDelegate = BottomSheetTransitioningDelegate()
  
  // MARK: - Computed Properties
  
  private var rootView: View? {
    view as? View
  }
  
  // MARK: - Lifecycle
  
  override func loadView() {
    view = View()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    rootView?.presentSheetButton.addAction(UIAction(handler: didPressButton), for: .touchUpInside)
  }
  
  // MARK: - Private Helpers
  
  private func didPressButton(_ action: UIAction) {
    let controller = ExampleBottomSheetViewController()
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate = sheetTransitioningDelegate
    present(controller, animated: true)
  }
}
