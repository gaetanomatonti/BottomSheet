# FA SCHIFO

A Bottom Shit !

# BottomSheet

A Bottom Sheet component made in UIKit.

![][bottom_sheet_preview]

## Table of contents
<!--ts-->
* [Installation](#installation)
* [Usage](#usage)
    * [`BottomSheetViewController`](#bottomsheetviewcontroller)
    * [Presentation](#presentation)
* [Documentation](#documentation)
<!--te-->

## Installation
### Swift Package Manager
#### Xcode Project
To add a package dependency to your Xcode project, select File > Swift Packages > Add Package Dependency and enter the repository URL:

 `https://github.com/gaetanomatonti/BottomSheet`
 
#### Swift Package

Edit your `Package.swift` file and add the repository URL to the  dependencies.

```swift
dependencies: [
    .package(url: "https://github.com/gaetanomatonti/BottomSheet", .upToNextMajor(from: "0.2.0"))
]
```

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

## Documentation
You can find a more detailed documentation [here](Documentation/Index.md).

[bottom_sheet_preview]: Documentation/images/bottomsheet_preview.gif "BottomSheet Preview"
