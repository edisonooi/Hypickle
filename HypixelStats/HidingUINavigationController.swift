//
//  HidingUINavigationController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/19/21.
//

import UIKit

class HidingUINavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension HidingUINavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
