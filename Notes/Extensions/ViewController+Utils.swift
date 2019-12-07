//
//  ViewController+Utils.swift
//  Notes
//
//  Created by Darya Kuliashova on 12/4/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let dismissKeyboardGuesture = UITapGestureRecognizer(target: self,
                                                             action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardGuesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
