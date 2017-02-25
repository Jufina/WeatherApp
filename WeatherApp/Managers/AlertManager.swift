//
//  AlertManager.swift
//  WeatherApp
//
//  Created by jufina on 24.02.17.
//  Copyright © 2017 jufina. All rights reserved.
//

import Foundation
import SwiftMessages

class AlertManager {
    
    static func showError(title: String, message: String) {
        let view = MessageView.viewFromNib(layout: .CardView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        view.configureContent(title: title, body: message)
        SwiftMessages.show(view: view)
    }
    static func showWarning(title: String, message: String) {
        let view = MessageView.viewFromNib(layout: .CardView)
        view.button?.isHidden = true
        view.configureTheme(.warning)
        view.configureContent(title: title, body: message)
        SwiftMessages.show(view: view)
    }
}
