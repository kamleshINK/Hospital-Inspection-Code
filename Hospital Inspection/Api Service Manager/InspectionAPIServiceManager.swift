//
//  InspectionAPIServiceManager.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 28/07/24.
//

import Foundation

class InspectionAPIServiceManager {
    
    func getInspectionDataAndStart(completionHandler: @escaping (Result<InspectionData, Error>) -> ()) {
        
        guard let url = URL(string: APIEndpoints.startInspection) else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let inspectionData = try JSONDecoder().decode(InspectionData.self, from: data)
                completionHandler(.success(inspectionData))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
    
    func submitInspectionData(inspectionData: InspectionData, completionHandler: @escaping (Result<(), Error>) -> ()) {
        guard let url = URL(string: APIEndpoints.submitInspection) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(inspectionData)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

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
