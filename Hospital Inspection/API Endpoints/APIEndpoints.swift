//
//  APIEndpoints.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 27/07/24.
//

import Foundation

class APIEndpoints {
    //static let baseUrl = "http://localhost:5001/api"
    static private let baseUrl = "http://127.0.0.1:5001/api"
    
    static let register = "\(APIEndpoints.baseUrl)/api/register"
    static let login = "\(APIEndpoints.baseUrl)/api/login"
    
    static let startInspection = "\(APIEndpoints.baseUrl)/inspections/start"
    static let submitInspection = "\(APIEndpoints.baseUrl)/inspections/submit"

}
