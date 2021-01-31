//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Valter A. Machado on 1/19/21.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
