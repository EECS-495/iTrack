//
//  CharRow.swift
//  Track
//
//  Created by Danielle Maraffino on 2/2/23.
//

import Foundation
import SwiftUI

struct CharRow: Hashable, Codable, Identifiable {
    var id: Int
    var CharType: Int
    var image: String
    var character: String
}
