//
//  TechnieProfileTVOptions.swift
//  Technie
//
//  Created by Valter A. Machado on 1/14/21.
//

import UIKit

enum TechnieProfileTVOptions: Int, CustomStringConvertible {
    
    case Account
    case ServiceHistory

    case HelpCenter
    case TellAFriend
    
    case Settings
    case Logout
    
    var description: String {
        switch self {
        case .Account: return "Account"
        case .ServiceHistory: return "Service History"

        case .HelpCenter: return "Help"
        case .TellAFriend: return "Tell a Friend"
            
        case .Settings: return "Settings"
        case .Logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Account:
            let iconImage = UIImage(systemName: "lock.circle.fill")
            return iconImage ?? UIImage()
            
        case .ServiceHistory:
            let iconImage = UIImage(systemName: "clock.arrow.circlepath")
            return iconImage ?? UIImage()
        
        case .HelpCenter:
            let iconImage = UIImage(systemName: "questionmark.circle")
            return iconImage ?? UIImage()
            
        case .TellAFriend:
            let iconImage = UIImage(systemName: "heart.circle.fill")
            return iconImage ?? UIImage()
            
        case .Settings:
            let iconImage = UIImage(systemName: "gearshape")
            return iconImage ?? UIImage()

        case .Logout:
            let iconImage = UIImage(systemName: "return")
            return iconImage ?? UIImage()
        }
    }
    
    
}

enum TechnieProfileTVOptions0: Int, CustomStringConvertible {
    case Account
    case SavedJobs
    
    var description: String {
        switch self {
        case .Account: return "Account"
        case .SavedJobs: return "Saved Jobs"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Account:
            let iconImage = UIImage(systemName: "person.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) ?? UIImage()
            let resizedImage = UIImage().resizeImage(image: iconImage, toTheSize: CGSize(width: 24, height: 24))
            return resizedImage
            
        case .SavedJobs:
            let iconImage = UIImage(systemName: "bookmark.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) ?? UIImage()
            let resizedImage = UIImage().resizeImage(image: iconImage, toTheSize: CGSize(width: 24, height: 24))
            return resizedImage
        }
    }
  
}

enum TechnieProfileTVOptions1: Int, CustomStringConvertible {
    case General
    case HelpCenter
    case TellAFriend
    
    var description: String {
        switch self {
        case .HelpCenter: return "Help"
        case .TellAFriend: return "Tell a Friend"
        case .General: return "General"
        }
    }
    
    var image: UIImage {
        switch self {
        case .HelpCenter:
            let iconImage = UIImage(systemName: "questionmark.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) ?? UIImage()
            let resizedImage = UIImage().resizeImage(image: iconImage, toTheSize: CGSize(width: 24, height: 24))
            return resizedImage
            
        case .TellAFriend:
            let iconImage = UIImage(systemName: "heart.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) ?? UIImage()
            let resizedImage = UIImage().resizeImage(image: iconImage, toTheSize: CGSize(width: 24, height: 24))
            return resizedImage
            
        case .General:
            let iconImage = UIImage(systemName: "gearshape.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) ?? UIImage()
            let resizedImage = UIImage().resizeImage(image: iconImage, toTheSize: CGSize(width: 24, height: 24))
            return resizedImage
        }
    }
}

enum TechnieProfileTVOptions2: Int, CustomStringConvertible {
//    case Settings
    case Logout
    
    var description: String {
        switch self {
//        case .Settings: return "Settings"
        case .Logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
//        case .Settings:
//            let iconImage = UIImage(systemName: "gearshape.fill")
//            return iconImage ?? UIImage()

        case .Logout:
            let iconImage = UIImage(systemName: "power")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            return iconImage ?? UIImage()
        }
    }
}
