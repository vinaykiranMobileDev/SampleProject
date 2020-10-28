//
//  NetworkManager.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation
import UIKit

protocol APICallBack {
    func onData(_ info: Any?)
    func onError(_ error: String)
}


class NetworkManager {
    let kBaseURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    var delegate: APICallBack?
    var isMockTest = false
    var isPositivetest = true
    func getTableDatat() {
        
        if isMockTest {
            
        }
        RestConnector().getCall(kBaseURL) {[weak self] (data, error) in
            if error != nil {
                self?.delegate?.onError(error?.localizedDescription ?? "Error")
                return
            }
            
            guard let aResponse = data else {
                self?.delegate?.onData(nil)
                return
            }
            
            do {
                let aStringData = String(decoding: aResponse, as: UTF8.self)
                if let aData = aStringData.data(using: .utf8) {
                    let aJsonData = try JSONDecoder().decode(Country.self, from: aData)
                    self?.delegate?.onData(aJsonData)
                } else  {
                    self?.delegate?.onError("Error")
                }
                
            } catch let aJsonError {
                self?.delegate?.onError(aJsonError.localizedDescription)
            }
        }
    }
    
    
    func downloadImageFrom(_ url: String) {
        RestConnector().downloadImage(url) {[weak self] (data, url ,error) in
            if error != nil {
                self?.delegate?.onError(error?.localizedDescription ?? "Error")
                return
            }
            
            guard let aResponse = data else {
                self?.delegate?.onData(nil)
                return
            }
            
            if let aImage = UIImage(data: aResponse) {
                
                var aDict = [String: Any]()
                aDict["image"] = aImage
                if let aRequestURL = url {
                    aDict["url"] = aRequestURL
                }
                self?.delegate?.onData(aDict)
            } else {
                self?.delegate?.onError(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    
    func getMockResponseData() {
        let data = Utility.fetchMockData()
        if isPositivetest {
            self.delegate?.onData(data)
        } else {
            self.delegate?.onError("Error")
        }
    }
    
}
