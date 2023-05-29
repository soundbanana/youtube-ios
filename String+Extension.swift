//
//  String+Extension.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 29.05.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "\(self) could not be found in Localizable.strings")
    }
}
