//
//  BiometryHelper.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation
import LocalAuthentication

class BiometryHelper: ObservableObject {
    
    @Published var biometricType: LABiometryType = .none
    
    fileprivate var context: LAContext?
  
    init(context: LAContext = .init()) {
        self.context = context
    }
    
    deinit {
        context = nil
    }
    
    private func askBiometricAvailability() throws {
        if let context {
            var failureReason: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &failureReason) {
                biometricType = context.biometryType
            } else {
                throw failureReason ?? NSError()
            }
        }
    }
    
    private func evaluatePolicy() async throws -> Bool {
        if let context {
            let reason = "Scan your face to log in."
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        }
        return false
    }
    
    func authenticate() async throws -> Bool {
        try askBiometricAvailability()
        return try await evaluatePolicy()
    }
}

//MARK: BiometryError
extension BiometryHelper {
    enum BiometryError: Error {
        case failed
    }
}
