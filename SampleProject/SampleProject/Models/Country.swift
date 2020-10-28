//
//  Country.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation


struct Country: Codable {
    var title: String?
    var rows: [Fact]
}


struct Fact: Codable {
    var title: String?
    var description: String?
    var imageHref: String?
}
