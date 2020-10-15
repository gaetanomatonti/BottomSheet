# BottomSheet

A Bottom Sheet component made in UIKit.

![](Documentation/image.gif)

## Usage

### `BottomSheetViewController`
This controller uses `BottomSheetView` as its main view. To specify custom content for the bottom sheet create your own view, and assign it to the `contentView` variable of the controller. You can either do this by subclassing `BottomSheetViewController`, to implement your own business logic, or by assigning the view at initialisation before presenting the sheet.

#### Example: subclassing `BottomSheetViewController`

```swift
final class CustomBottomSheetViewController: BottomSheetViewController {
    override func loadView() {
        super.loadView()
        	
        let myView = UIView()
        myView.backgroundColor = .red
		
        contentView = myView
    }
}
```

#### Example: assignment on init

```swift
func presentBottomSheet() {
    let controller = BottomSheetViewController()
    controller.contentView = UIView()
    ...
}
```

### Presentation
Make your app delegate adopt the `BottomSheetPresenter` protocol and instantiate a `BottomSheetTransitioningDelegate` object.

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BottomSheetPresenter {
    let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()
    ... 
}
```

Instantiate your `BottomSheetViewController` and present it.

```swift
final class ViewController: UIViewController {
    ... 
    
    func presentBottomSheet() {
        let controller = BottomSheetViewController()
        present(controller, animated: true, completion: nil)
    }
}
```

That's it!

#### Alternative method
Adopt the `BottomSheetPresenter` in the presenting controller and assign the `bottomSheetTransitioningDelegate` to your bottom sheet controller.

```swift
final class ViewController: UIViewController, BottomSheetPresenter {
    let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()
    
    func presentBottomSheet() {
        let controller = BottomSheetViewController()
        controller.transitioningDelegate = bottomSheetTransitioningDelegate
        present(controller, animated: true, completion: nil)
    }
}
```