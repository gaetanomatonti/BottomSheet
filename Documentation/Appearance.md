# Appearance

<!--ts-->
* [`SheetSizingStyle`](#sheetsizingstyle)
* [`HandleStyle`](#handlestyle)
<!--te-->

## `SheetSizingStyle`
Defines the way the sheet should layout.

| Case name | Description  | Image |
| :--: | :--: | :--: |
| `adaptive` | Adapts the size of the bottom sheet to its content. If the content height is greater than the available frame height, it behaves like `toSafeAreaTop`. | ![][sheetSizingStyle_adaptive]
| `fixed(height:)` | Sets a fixed height for the sheet. If `height` is greater than the available frame height it behaves like `toSafeAreaTop`. | ![][sheetSizingStyle_fixed]
| `toSafeAreaTop` | Aligns the top of the bottom sheet to the top safe area inset. | ![][sheetSizingStyle_toSafeArea]

## `HandleStyle`
Defines the style of the handle.

| Case name | Description  | Image |
| :--: | :--: | :--: |
| `none` | No handle is drawn. | ![][handleStyle_none]
| `inside` | Shows the handle inside the content view. | ![][handleStyle_inside]
| `outside` | Shows the handle outside the sheet, on its top. | ![][handleStyle_outside]

[sheetSizingStyle_adaptive]: images/sheetSizingStyle_adaptive.png "Sheet Sizing Style: adaptive"
[sheetSizingStyle_fixed]: images/sheetSizingStyle_fixed.png "Sheet Sizing Style: fixed"
[sheetSizingStyle_toSafeArea]: images/sheetSizingStyle_toSafeArea.png "Sheet Sizing Style: to safe area"

[handleStyle_none]: images/handleStyle_none.png "Handle Style: none"
[handleStyle_inside]: images/handleStyle_inside.png "Handle Style: inside"
[handleStyle_outside]: images/handleStyle_outside.png "Handle Style: outside"