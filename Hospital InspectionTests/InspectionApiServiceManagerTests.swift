//
//  InspectionApiServiceManagerTests.swift
//  Hospital InspectionTests
//
//  Created by Kamlesh Nimradkar on 29/07/24.
//

import XCTest

@testable import Hospital_Inspection

final class InspectionApiServiceManagerTests: XCTestCase {
    
    func testStartInspectionWhichReturnsSuccess() {
        //Arrange
        let apiServiceManager = InspectionAPIServiceManager()
        let expectation = self.expectation(description: "Inspection Data fetched")

        //Act
        apiServiceManager.getInspectionDataAndStart { result in
            //Assert
            switch result {
            case .success(let inspectionData):
                XCTAssertTrue(true)
                XCTAssertNotNil(inspectionData)

            case .failure(let error):
                XCTFail("expected to be success but got a failure with error \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
