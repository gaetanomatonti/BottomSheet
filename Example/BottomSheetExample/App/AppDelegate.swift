//
//  AppDelegate.swift
//  BottomSheetExample
//
//  Created by Gaetano Matonti on 22/11/20.
//

import UIKit
import BottomSheet

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BottomSheetPresenter {
  var window: UIWindow?
  
  let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    return true
  }
}
