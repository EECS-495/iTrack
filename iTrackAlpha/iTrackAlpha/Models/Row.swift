//
//  Row.swift
//  Track
//
//  Created by Danielle Maraffino on 2/1/23.
//

import Foundation
import SwiftUI

struct Row: Hashable, Codable, Identifiable {
    var id: Int
    var image: String
    var RowType: Int
    var CharType: Int
}

