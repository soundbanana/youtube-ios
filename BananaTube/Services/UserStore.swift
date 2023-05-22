//
//  UserStore.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 21.05.2023.
//

import Combine

class UserStore {
    static let shared = UserStore()

    private let signInSubject = PassthroughSubject<Void, Never>()
    private let signOutSubject = PassthroughSubject<Void, Never>()

    var userStatePublisher: AnyPublisher<State, Never> {
        Publishers.Merge(signInSubject.map { _ in .authorized }, signOutSubject.map { _ in .unauthorized })
            .eraseToAnyPublisher()
    }

    func signIn() {
        signInSubject.send()
    }

    func signOut() {
        signOutSubject.send()
    }
}
