//
//  AuthenticationApiServiceManagerTests.swift
//  Hospital InspectionTests
//
//  Created by Kamlesh Nimradkar on 28/07/24.
//

import XCTest
@testable import Hospital_Inspection

final class AuthenticationApiServiceManagerTests: XCTestCase {
    
    func testRegisterWithValidRequestReturnsSuccess() {
        //Arrange
        let request = AuthenticationRequest(email: "kamlesh@test.com", password: "test@123" )
        guard let urlRequest = AuthenticationType.register.getUrlRequest(request: request) else { return }
        let apiServiceManager = AuthenticationAPIServiceManager()
        let expectation = self.expectation(description: "User registered")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("expected to be success but got a failure with error \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoginWithValidRequestReturnsSuccess() {
        //Arrange
        let request = AuthenticationRequest(email: "kamlesh@test.com", password: "test@123" )
        guard let urlRequest = AuthenticationType.login.getUrlRequest(request: request) else { return }
        let apiServiceManager = AuthenticationAPIServiceManager()
        let expectation = self.expectation(description: "User successfully login")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("expected to be success but got a failure with error \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRegisterWithExistingUserReturnsFailureWithError() {
        //Arrange
        let request = AuthenticationRequest(email: "kamlesh@test.com", password: "test@123" )
        guard let urlRequest = AuthenticationType.register.getUrlRequest(request: request) else { return }
        let apiServiceManager = AuthenticationAPIServiceManager()
        let expectation = self.expectation(description: "User already exists error")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTFail("expected to be failure but got a success with error")
            case .failure(let error as NSError):
                XCTAssertTrue(true)
                XCTAssertEqual(401, error.code)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginWithNonExististingUserReturnsFailureWithError() {
        //Arrange
        let request = AuthenticationRequest(email: "tester@test.com", password: "test@123" )
        guard let urlRequest = AuthenticationType.login.getUrlRequest(request: request) else { return }
        let apiServiceManager = AuthenticationAPIServiceManager()
        let expectation = self.expectation(description: "User doesn't exists error")
        
        //Act
        apiServiceManager.authenticateUser(urlRequest: urlRequest) { result in
            //Assert
            switch result {
            case .success:
                XCTFail("expected to be failure but got a success with error")
            case .failure(let error as NSError):
                XCTAssertTrue(true)
                XCTAssertEqual(401, error.code)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

}
