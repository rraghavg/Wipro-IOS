//
//  ViewController.swift
//  Wipro IOS
//
//  Created by Raghav Gupta on 12/11/26.
//



import UIKit

class ViewController: UIViewController {

    // Creating labels and button
    let titleLabel = UILabel()
    let nameField = UITextField()
    let submitButton = UIButton(type: .system)
    let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Title
        titleLabel.text = "My First App"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.frame = CGRect(x: 50, y: 150, width: 300, height: 50)
        titleLabel.textAlignment = .center

        // Text Field
        nameField.placeholder = "Enter your name"
        nameField.borderStyle = .roundedRect
        nameField.frame = CGRect(x: 40, y: 230, width: 320, height: 40)

        // Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.frame = CGRect(x: 140, y: 300, width: 120, height: 40)

        // Connecting button with function
        submitButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        // Result Label
        resultLabel.frame = CGRect(x: 40, y: 370, width: 320, height: 50)
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 22)

        // Adding all controls to screen
        view.addSubview(titleLabel)
        view.addSubview(nameField)
        view.addSubview(submitButton)
        view.addSubview(resultLabel)
    }

    // Button click function
    @objc func buttonClicked() {

        if nameField.text == "" {
            resultLabel.text = "Please enter your name"
        } else {
            resultLabel.text = "Hello " + nameField.text!
        }
    }
}
