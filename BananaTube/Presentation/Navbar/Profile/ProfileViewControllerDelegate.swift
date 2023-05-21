//
//  ProfileViewControllerDelegate.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 21.05.2023.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func didSignIn()
    func didSignOut()
}
