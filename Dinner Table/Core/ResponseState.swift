//
//  ResponseState.swift
//  Foundadtion
//
//  Created by Erez Hod on 5/7/25.
//

import SwiftUI

enum ResponseState {
    case ready, generating
    
    var actionTitle: String {
        switch self {
        case .ready: "Embarass Me"
        case .generating: "Generating..."
        }
    }
    
    var actionColor: Color {
        switch self {
        case .ready: .blue
        case .generating: .gray.opacity(0.3)
        }
    }
}
