//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import Foundation

final class UserDefaultsService {
    
    // MARK: - Public Properties
    
    static let shared = UserDefaultsService()
    
    var hasLaunched: Bool {
        get {
            storage.bool(forKey: Keys.isFirstLaunch.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.isFirstLaunch.rawValue)
        }
    }
    
    // MARK: - Private Properties
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case isFirstLaunch
    }
    
    // MARK: - Initializers
    
    private init() {}
}
