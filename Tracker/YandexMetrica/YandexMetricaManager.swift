//
//  YandexMetricaManager.swift
//  Tracker
//
//  Created by Nikita Khon on 17.07.2025.
//

import Foundation
import YandexMobileMetrica

final class YandexMetricaManager {
    
    // MARK: - Public Properties
    
    static let shared = YandexMetricaManager()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func initialize() {
        if let configuration = YMMYandexMetricaConfiguration(apiKey: "0ffd3391-24df-4708-bb8d-7918c96f55a7") {
            YMMYandexMetrica.activate(with: configuration)
        }
    }
}
