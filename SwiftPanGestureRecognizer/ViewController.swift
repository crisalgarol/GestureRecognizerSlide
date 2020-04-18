//
//  ViewController.swift
//  SwiftPanGestureRecognizer
//
//  Created by Cristian Salomon Garcia Olmedo on 21/03/20.
//  Copyright © 2020 Cristian Salomon Garcia Olmedo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var sunView: UIImageView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var topContainerViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var topSunConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  var startingTopConstant: CGFloat = 0.0
  var startingTopSunConstant: CGFloat = 0.0
  let correctSunPositionOnExpandedView: CGFloat = 0.0
  let correctContainerPositionOnExpandedCollapsed: CGFloat = 380
  var previousPositionContainer: CGFloat = 0.0
  var previousSunPosition: CGFloat = 0.0
  
  enum containerStatus {
    case collapsed
    case expanded
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setUpUI()
    startingTopConstant = topContainerViewConstraint.constant
  }
  
  func setUpUI() {
    containerView.isUserInteractionEnabled = true
    containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture)))
  }

  @objc func handleGesture(gesture: UIPanGestureRecognizer) {
    
    if gesture.state == .began {
      print("🎃 Gesture began")
      startingTopConstant = topContainerViewConstraint.constant
      startingTopSunConstant = topSunConstraint.constant
      print("Initial sun position \(startingTopSunConstant)")
      
    } else if gesture.state == .changed {
      
        let translation = gesture.translation(in: self.view)
        let newPositionContainer = self.startingTopConstant + translation.y
        let newPositionSun = -(self.startingTopSunConstant + translation.y)
        
        if newPositionContainer <= 380 && newPositionContainer >= 50 {
          self.topContainerViewConstraint.constant = newPositionContainer
        }
        
        if newPositionSun >= 0 && newPositionSun <= 200 {
          self.topSunConstraint.constant = newPositionSun
        }
        
      UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
      }, completion: nil)
      
      previousPositionContainer = newPositionContainer
      previousSunPosition = newPositionSun
      
      print("Se está moviendo el sol : \(newPositionSun)")
      
    } else if gesture.state == .ended {
      
      print("⛑ Ended")
      if previousPositionContainer <= 290 {
        self.topContainerViewConstraint.constant = 50
        self.topSunConstraint.constant = 380
        previousPositionContainer = 50
        previousSunPosition = 380
      } else if previousPositionContainer > 290 {
        self.topContainerViewConstraint.constant = 380
        self.topSunConstraint.constant = 0
        previousPositionContainer = 380
        previousSunPosition = 0
      }
      
      UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
      }, completion: nil)
      print("Sun position ☀️ \(topSunConstraint.constant)")
    }
  }

}

