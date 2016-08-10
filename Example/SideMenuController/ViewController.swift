//
//  ViewController.swift
//  SideMenuController
//
//  Created by Ryan Fitzgerald on 08/10/2016.
//  Copyright (c) 2016 Ryan Fitzgerald. All rights reserved.
//

import UIKit
import SideMenuController

class ViewController: UIViewController {

  let leftSideMenuController = PCSideMenuTransitionDelegate(menuPosition: .Left)
  let rideSideMenuController = PCSideMenuTransitionDelegate(menuPosition: .Right)

  lazy var leftViewController: UIViewController = {
    let result = UIViewController()
    result.view.backgroundColor = UIColor.redColor()
    result.modalPresentationStyle = .Custom
    result.transitioningDelegate = self.leftSideMenuController

    return result
  }()

  lazy var rightViewController: UIViewController = {
    let result = UIViewController()
    result.view.backgroundColor = UIColor.blueColor()
    result.modalPresentationStyle = .Custom
    result.transitioningDelegate = self.rideSideMenuController
    return result
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Side Menu Controller"

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Done, target: self, action: #selector(leftTapped(_:)))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .Done, target: self, action: #selector(rightTapped(_:)))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func leftTapped(sender: AnyObject) {
    print("open left side menu")
    self.presentViewController(leftViewController, animated: true, completion: nil)
  }

  func rightTapped(sender: AnyObject) {
    print("open right side menu")
    self.presentViewController(rightViewController, animated: true, completion: nil)
  }
}
