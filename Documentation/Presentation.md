# Presentation

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

