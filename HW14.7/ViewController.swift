//
//  ViewController.swift
//  HW14.7
//
//  Created by Илья Перевозкин on 22.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func nameEditingChanged(_ sender: Any) {
            PersistanceUserDefaults.shared.userName = nameTextField.text
    }
    
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBAction func secondNameChanged(_ sender: Any) {
        PersistanceUserDefaults.shared.secondUserName = secondNameTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = PersistanceUserDefaults.shared.userName
        secondNameTextField.text = PersistanceUserDefaults.shared.secondUserName
        self.hideKeyboardWhenTappedAround()
    }


}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

