//
//  LoginTests.swift
//  TheMovieDBTests
//
//  Created by Lucas Bighi on 16/08/23.
//

import XCTest
@testable import TheMovieDB

final class LoginTests: XCTestCase {

    var sut: LoginViewModelTest!
    
    override func setUp() {
        sut = LoginViewModelTest()
    }
    
    func testAuthenticationShouldWork() async {
        sut.username = "someuser"
        sut.password = "*Password123"
        await sut.login()
        XCTAssertFalse(sut.isLoading)
    }
    
    func testAuthenticationShouldNotWork() async {
        sut.errorMessage = NetworkError.decodeError.errorDescription
        XCTAssertEqual(sut.errorMessage, "Invalid object")
    }
}
