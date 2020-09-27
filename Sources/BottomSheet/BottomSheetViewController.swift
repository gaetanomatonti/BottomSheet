#if canImport(UIKit)
import UIKit

public final class BottomSheetViewController: UIViewController {
    
    private let bottomSheetView = BottomSheetView()
    
    var contentView: UIView {
        get { bottomSheetView.contentView }
        set { bottomSheetView.contentView = newValue }
    }
    
//    public override var view: UIView! {
//        get { bottomSheetView.contentView }
//        set { bottomSheetView.contentView = newValue }
//    }
    
    public override func loadView() {
        super.loadView()
        
        view = bottomSheetView.contentView
    }
        
}
#endif

#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI

struct BottomSheetViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = BottomSheetViewController
    
    func makeUIViewController(context: Context) -> BottomSheetViewController {
        let controller = BottomSheetViewController()
        controller.contentView.backgroundColor = .systemPink
        return controller
    }
    
    func updateUIViewController(_ uiViewController: BottomSheetViewController, context: Context) {
        
    }
}

struct BottomSheetViewControllerPreview: PreviewProvider {
    static var previews: some View {
        BottomSheetViewControllerRepresentable()
    }
}
#endif
