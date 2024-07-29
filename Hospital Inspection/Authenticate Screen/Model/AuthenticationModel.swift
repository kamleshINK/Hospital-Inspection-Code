//
//  AuthenticationModel.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 26/07/24.
//

import Foundation

struct AuthenticationRequest: Encodable {
    let email: String
    let password: String
}

enum AuthenticationType {
    case register
    case login
    
    var authenticationButtonName: String {
        switch self {
        case .register:
            return "Register"
        case .login:
            return "Login"
        }
    }
    
    var error400Message: String {
        return "Invalid user or password"
    }
    
    var error401Message: String {
        switch self {
        case .register:
            return "User already exists"
        case .login:
            return "User does not exist or the credentials are incorrect"
        }
    }
    
    var emptyEmailPasswordMessage: String {
        return "Email & Password cannot be empty"
    }
    
    
    func getUrlRequest(request: AuthenticationRequest) -> URLRequest? {
        var urlRequest: URLRequest
        switch self {
        case .register:
            guard let url = URL(string: APIEndpoints.register) else { return nil}
            urlRequest = URLRequest(url: url)
        case .login:
            guard let url = URL(string: APIEndpoints.login) else { return nil}
            urlRequest = URLRequest(url: url)
        }
        
        urlRequest.httpMethod = "post"

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch  {
            debugPrint("Encoding request body failed")
        }

        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        return urlRequest

    }
    
}
