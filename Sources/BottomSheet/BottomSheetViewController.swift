#if canImport(UIKit)
import UIKit

public final class BottomSheetViewController: UIViewController {
    
    private let bottomSheetView = BottomSheetView()
    
    public var handleStyle: BottomSheetView.HandleStyle {
        get { bottomSheetView.handleStyle }
        set { bottomSheetView.handleStyle = newValue }
    }
    
    public var contentView: UIView {
        get { bottomSheetView.contentView }
        set { bottomSheetView.contentView = newValue }
    }
    
    public init(handleStyle: BottomSheetView.HandleStyle) {
        super.init(nibName: nil, bundle: nil)
        self.handleStyle = handleStyle
        modalPresentationStyle = .custom
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .custom
    }
        
    public override func loadView() {
        super.loadView()

        view = bottomSheetView
        
        guard let view = view as? BottomSheetView else { return }
        view.accessibilityIdentifier = "Bottom Sheet"
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
