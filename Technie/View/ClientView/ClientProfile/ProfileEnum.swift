//
//  ProfileEnum.swift
//  Technie
//
//  Created by Valter A. Machado on 12/25/20.
//

import Foundation
import UIKit

enum TableViewOptions: Int, CustomStringConvertible {
    
    case EditProfile
    case ServiceHistory
    case HelpCenter
    case TellAFriend
    case Settings
    case Logout
    
    var description: String {
        switch self {
        case .EditProfile: return "Edit Profile"
        case .ServiceHistory: return "Service History"
        case .HelpCenter: return "Help"
        case .TellAFriend: return "Tell a Friend"
        case .Settings: return "Settings"
        case .Logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .EditProfile:
            let iconImage = UIImage(systemName: "square.and.pencil")
            return iconImage ?? UIImage()
        
        case .ServiceHistory:
            let iconImage = UIImage(systemName: "clock.arrow.circlepath")
            return iconImage ?? UIImage()
            
        case .HelpCenter:
            let iconImage = UIImage(systemName: "questionmark.circle")
            return iconImage ?? UIImage()
        
        case .TellAFriend:
            let iconImage = UIImage(systemName: "heart.circle")
            return iconImage ?? UIImage()
            
        case .Settings:
            let iconImage = UIImage(systemName: "gearshape")
            return iconImage ?? UIImage()

        case .Logout:
            let iconImage = UIImage(systemName: "power")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            return iconImage ?? UIImage()
        }
    }
    
    
}
