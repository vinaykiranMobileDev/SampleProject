//
//  Utility.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation

open class Utility {
    open class func fetchMockData() -> Any? {
        if let aFileURl = Bundle.main.url(forResource: "MOckData", withExtension: "json") {
            do {
                return try JSONDecoder().decode(Country.self, from: Data(contentsOf: aFileURl))
            } catch let error{
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
}
