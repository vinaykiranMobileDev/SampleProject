//
//  RestConnector.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation

class RestConnector: NSObject {
    
    var session = URLSession.shared
    
    public func getCall(_ urlString: String,  complitionHandler:@escaping (Data?, Error?) -> Void) {
        
        guard let aURL = URL(string: urlString) else {
            complitionHandler(nil, nil)
            return
        }
        
        var aRequest = URLRequest(url: aURL)
        aRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: aRequest) { (data, response, error) in
            if error != nil {
                complitionHandler(nil, error)
                return
            }
            
            complitionHandler(data,error)
            
        }
        
        task.resume()
    }
    
    
    func downloadImage(_ urlString: String,  complitionHandler:@escaping (Data?,String?,Error?) -> Void) {
        guard let aURL = URL(string: urlString) else {
            complitionHandler(nil,nil, nil)
            return
        }
        
        let aRequest = URLRequest(url: aURL)
        let task = session.downloadTask(with: aRequest) { (url, response, error) in
            if error != nil {
                complitionHandler(nil,nil,error)
                return
            }
            
            if let aURL = url {
                do {
                    let aData = try Data(contentsOf: aURL)
                    var aURL = ""
                    if let aResponse = response as? HTTPURLResponse {
                        aURL = aResponse.url?.absoluteString ?? ""
                    }
                    complitionHandler(aData,aURL,nil)
                } catch let aError {
                    complitionHandler(nil, nil, aError)
                }
            } else {
                complitionHandler(nil,nil, error)
            }
            
        }
        task.resume()
    }// (response as! HTTPURLResponse).url
}
