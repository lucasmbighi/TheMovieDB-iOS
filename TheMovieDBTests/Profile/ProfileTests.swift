//
//  ProfileTests.swift
//  TheMovieDBTests
//
//  Created by Lucas Bighi on 23/08/23.
//

import XCTest
@testable import TheMovieDB

final class ProfileTests: XCTestCase {

    var sut: ProfileViewModelTest!
    
    override func setUp() {
        sut = .init()
    }

    func testGetAccountDetailsShouldSucceed() async {
        await sut.getAccountDetails()
        XCTAssertNotNil(sut.accountDetails)
    }
}
