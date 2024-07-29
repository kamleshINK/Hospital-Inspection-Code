//
//  AuthenticationVM.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 26/07/24.
//

import Foundation

protocol UpdateAuthenticationVCProtocol: AnyObject {
    func pushToVC()
    func showAlert(message: String)
}

class AuthenticationVM {
    //MARK: - stored properties
    var authenticationType: AuthenticationType = .register
    
    weak var updateDelegate: UpdateAuthenticationVCProtocol?
    private let authenticationApiServiceManager = AuthenticationAPIServiceManager()
    
    func authenticateUser(request: AuthenticationRequest) {
        guard !request.email.isEmpty, !request.password.isEmpty else {
            updateDelegate?.showAlert(message: authenticationType.emptyEmailPasswordMessage)
            return
        }
        
        guard let urlRequest = authenticationType.getUrlRequest(request: request) else { return }
        
        authenticationApiServiceManager.authenticateUser(urlRequest: urlRequest) { [weak self] result in
            guard let wSelf = self else { return }
            switch result {
            case .success:
                wSelf.updateDelegate?.pushToVC()
            case .failure(let error as NSError):
                var message: String
                switch error.code {
                case 400:
                    message = wSelf.authenticationType.error400Message
                case 401:
                    message = wSelf.authenticationType.error401Message
                default:
                    message = error.localizedDescription
                }
                wSelf.updateDelegate?.showAlert(message: message)
            }
        }
    }
    
}
