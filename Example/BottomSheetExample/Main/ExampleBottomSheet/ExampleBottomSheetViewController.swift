//
//  BottomSheetExample
//

import UIKit

final class ExampleBottomSheetViewController: UIViewController {
  
  var rootView: ExampleBottomSheetView? {
    view as? ExampleBottomSheetView
  }
  
  // MARK: - Lifecycle
  
  override func loadView() {
    view = ExampleBottomSheetView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    rootView?.didTapButton = { [weak self] in
      self?.dismiss(animated: true)
    }
  }
}
