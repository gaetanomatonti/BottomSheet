//
//  ViewModel.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import BottomSheet

protocol Item {
    var title: String { get }
}

final class ViewModel {
    
    struct SheetSizingItem: Item {
        let style: BottomSheetView.SheetSizingStyle
        let title: String
    }
    
    let sheetSizingItems: [SheetSizingItem] = [
        .init(style: .adaptive, title: "Adaptive"),
        .init(style: .fixed(height: 480), title: "Fixed"),
        .init(style: .toSafeAreaTop, title: "Safe Area")
    ]
    
    var selectedSheetSizingStyle: BottomSheetView.SheetSizingStyle = .adaptive
    
    struct HandleStyle: Item {
        let style: BottomSheetView.HandleStyle
        let title: String
    }
    
    let handleStyleItems: [HandleStyle] = [
        .init(style: .none, title: "None"),
        .init(style: .inside, title: "Inside"),
        .init(style: .outside, title: "Outside")
    ]
    
    var selectedHandleStyle: BottomSheetView.HandleStyle = .none
    
}
