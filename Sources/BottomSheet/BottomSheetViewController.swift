#if canImport(UIKit)
import UIKit

public class BottomSheetViewController: UIViewController {
    
    private let bottomSheetView = BottomSheetView()
    
    public var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
        get { bottomSheetView.sheetSizingStyle }
        set { bottomSheetView.sheetSizingStyle = newValue }
    }
    
    public var handleStyle: BottomSheetView.HandleStyle {
        get { bottomSheetView.handleStyle }
        set { bottomSheetView.handleStyle = newValue }
    }
    
    public var contentView: UIView {
        get { bottomSheetView.contentView }
        set { bottomSheetView.contentView = newValue }
    }
    
    public var contentBackgroundColor: UIColor {
        get { bottomSheetView.contentBackgroundColor }
        set { bottomSheetView.contentBackgroundColor = newValue }
    }
    
    public var sheetCornerRadius: CGFloat {
        get { bottomSheetView.cornerRadius }
        set { bottomSheetView.cornerRadius = newValue }
    }
    
    public var contentInsets: UIEdgeInsets {
        get { bottomSheetView.contentInsets }
        set { bottomSheetView.contentInsets = newValue }
    }
    
    public init(handleStyle: BottomSheetView.HandleStyle = .none, cornerRadius: CGFloat = 16) {
        super.init(nibName: nil, bundle: nil)
        
        self.handleStyle = handleStyle
        self.sheetCornerRadius = cornerRadius
        
        commonInit()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        modalPresentationStyle = .custom
        transitioningDelegate = (UIApplication.shared.delegate as? BottomSheetPresenter)?.bottomSheetTransitioningDelegate
    }
    
    public override func loadView() {
        super.loadView()

        view = bottomSheetView
        bottomSheetView.accessibilityIdentifier = "Bottom Sheet"
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
