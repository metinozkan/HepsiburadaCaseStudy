//
//  search.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import Foundation

struct allSearch: Codable {
    var resultCount : Int?
    var results : [Result]?
}

struct Result: Codable {
    var collectionName: String?
    var collectionPrice : Float?
    var artworkUrl100 : String?
    var releaseDate: String?
}
