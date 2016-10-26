//
//  ViewController.swift
//  SideMenuController
//
//  Created by Ryan Fitzgerald on 08/10/2016.
//  Copyright (c) 2016 Ryan Fitzgerald. All rights reserved.
//

import UIKit
import PCSideMenuController

class ViewController: UIViewController {

  let leftSideMenuController = PCSideMenuTransitionDelegate(menuPosition: .left)
  let rideSideMenuController = PCSideMenuTransitionDelegate(menuPosition: .right)

  lazy var leftViewController: UIViewController = {
    let result = UIViewController()
    result.view.backgroundColor = UIColor.red
    result.modalPresentationStyle = .custom
    self.leftSideMenuController?.backdropColor = UIColor.yellow
    result.transitioningDelegate = self.leftSideMenuController

    return result
  }()

  lazy var rightViewController: UIViewController = {
    let result = UIViewController()
    result.view.backgroundColor = UIColor.blue
    result.modalPresentationStyle = .custom
    result.transitioningDelegate = self.rideSideMenuController
    return result
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Side Menu Controller"

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .done, target: self, action: #selector(self.leftTapped(sender:)))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .done, target: self, action: #selector(self.rightTapped(sender:)))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func leftTapped(sender: AnyObject) {
    print("open left side menu")
    self.present(leftViewController, animated: true, completion: nil)
  }

  func rightTapped(sender: AnyObject) {
    print("open right side menu")
    self.present(rightViewController, animated: true, completion: nil)
  }
}
