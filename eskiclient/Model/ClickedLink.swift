//
//  ClickedLink.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.10.2020.
//

import Foundation

struct ClickedLink: Identifiable {
    var id: String {
        return text
    }
    
    var url: URL
    var text: String
}
