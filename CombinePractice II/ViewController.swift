//
//  ViewController.swift
//  CombinePractice II
//
//  Created by Ting on 2023/11/20.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var acceptedSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // Define publishers
    @Published private var acceptedTerms = false
    @Published private var acceptedPrivacy = false
    @Published private var name = ""
    
    // Combine publishers into single stream
    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($acceptedTerms, $acceptedPrivacy, $name) // add attribute
            .map { terms, privacy, name in // insert logic here
                return terms && privacy && !name.isEmpty
            }.eraseToAnyPublisher()
    }
    
    // Define subscriber
    // AnyCancellable: Avoid to memory leak
    private var buttonSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        // Hook subscriber up to publisher
        buttonSubscriber = validToSubmit
            .receive(on: RunLoop.main) // return to main thread
            .assign(to: \.isEnabled, on: submitButton )
    }

    @IBAction func acceptTerms(_ sender: UISwitch) {
        acceptedTerms = sender.isOn
    }
    
    @IBAction func acceptPrivacy(_ sender: UISwitch) {
        acceptedPrivacy = sender.isOn
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

