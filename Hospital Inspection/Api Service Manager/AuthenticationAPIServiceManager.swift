//
//  AuthenticationAPIServiceManager.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 27/07/24.
//

import Foundation

class AuthenticationAPIServiceManager {
    
    func authenticateUser(urlRequest: URLRequest, completionHandler: @escaping(Result<(), Error>)->()) {

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 200 {
                completionHandler(.success(()))
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
