//
//  NetworkManagerTest.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import XCTest

@testable import SampleProject

class NetworkManagerTest: XCTestCase, APICallBack{
   var networkManager: NetworkManager? = nil
   override class func setUp() {
       super.setUp()
      
   }
   override class func tearDown() {
       super.tearDown()
   }
   
   func initilizeNetworkManger() {
       networkManager = NetworkManager()
       networkManager?.delegate = self
   }
   
   func testMockPositiveResponse() {
       self.initilizeNetworkManger()
       networkManager?.isMockTest = true
       networkManager?.isPositivetest = true
       networkManager?.getTableDatat()
   }
   
   func testMockNegativeResponse() {
       self.initilizeNetworkManger()
       networkManager?.isMockTest = true
       networkManager?.isPositivetest = false
       networkManager?.getTableDatat()
   }
   
   func onData(_ info: Any?) {
       if let data =  info as? Country {
           XCTAssertEqual(data.title, "About Canada")
           XCTAssertEqual(data.rows.count, 14)
           XCTAssertFalse((data.title?.isEmpty ?? false))
           XCTAssertFalse(data.rows.isEmpty)
       }
   }
   
   func onError(_ error: String) {
       XCTAssertEqual(error, "Error")
   }
   
}
