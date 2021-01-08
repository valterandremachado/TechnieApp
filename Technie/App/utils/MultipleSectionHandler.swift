//
//  MultipleSectionHandler.swift
//  Technie
//
//  Created by Valter A. Machado on 1/8/21.
//

import Foundation

struct SectionHandler {
    var sectionTitle: String?
    var sectionDetail: [String]
    
    init(title: String, detail: [String]) {
        self.sectionTitle = title
        self.sectionDetail = detail
    }
}
