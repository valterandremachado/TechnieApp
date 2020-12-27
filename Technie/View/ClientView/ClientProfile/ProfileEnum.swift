//
//  ProfileEnum.swift
//  Technie
//
//  Created by Valter A. Machado on 12/25/20.
//

import Foundation
import UIKit

enum TableViewOptions: Int, CustomStringConvertible {
    
    case VoiceMapping
    case Settings
    case HelpCenter
    case Logout
    
    var description: String {
        switch self {
        case .VoiceMapping: return "Voice Mapping"
        case .Settings: return "Settings"
        case .HelpCenter: return "Help Center"
        case .Logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .VoiceMapping:
            let iconImage = UIImage(systemName: "map")
            return iconImage ?? UIImage()
            
        case .Settings:
            let iconImage = UIImage(systemName: "gear")
            return iconImage ?? UIImage()
            
        case .HelpCenter:
            let iconImage = UIImage(systemName: "questionmark.circle.fill")
            return iconImage ?? UIImage()

        case .Logout:
            let iconImage = UIImage(systemName: "return")
            return iconImage ?? UIImage()
        }
    }
    
    
}
