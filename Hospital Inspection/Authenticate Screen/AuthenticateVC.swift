//
//  AuthenticateVC.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 25/07/24.
//

import UIKit

class AuthenticateVC: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var authSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var authenticationButton: UIButton!
    
    //MARK: Properties
    let authenticationViewModel: AuthenticationVM = AuthenticationVM()

    
    // MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfield()
        setUIForAuthenticationType()
        authenticationButton.layer.cornerRadius = 24
        
        authenticationViewModel.updateDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTxtField.text = ""
        passwordTxtField.text = ""
    }

    // MARK: - Button Actions
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case .zero:
            authenticationViewModel.authenticationType = .register
        default:
            authenticationViewModel.authenticationType = .login
        }
        
        setUIForAuthenticationType()
    }
    
    
    @IBAction func authenticationButtonAction(_ sender: UIButton) {
        guard let email = emailTxtField.text, let password = passwordTxtField.text else { return }
        let request = AuthenticationRequest(email: email, password: password)
        authenticationViewModel.authenticateUser(request: request)
    }
    
    
    //MARK: - View Set up methods
    func setTextfield() {
        emailTxtField.setTxtFieldPlaceholder(text: "Email")
        passwordTxtField.setTxtFieldPlaceholder(text: "Password")
        
        emailTxtField.addBottomBorderWithColor(color: UIColor.lightGray)
        passwordTxtField.addBottomBorderWithColor(color: UIColor.lightGray)
        
        emailTxtField.addPadding()
        passwordTxtField.addPadding()
    }
    
    func setUIForAuthenticationType() {
        authenticationButton.setTitle(authenticationViewModel.authenticationType.authenticationButtonName, for: .normal)
    }
    
}

extension AuthenticateVC: UpdateAuthenticationVCProtocol {
    //MARK: - UpdateAuthenticationVCProtocol Methods
    func pushToVC() {
        DispatchQueue.main.async { [weak self] in
            let inspectionVC = InspectionViewController(nibName: "InspectionViewController", bundle: nil)
            self?.navigationController?.pushViewController(inspectionVC, animated: true)
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlertMessage(message)
        }
    }
}
