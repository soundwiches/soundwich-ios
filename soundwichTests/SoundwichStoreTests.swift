//
//  SoundwichStoreTests.swift
//  soundwich
//
//  Created by Tommy Chheng on 10/7/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import XCTest
@testable import soundwich

class SoundwichStoreTests:XCTestCase {
    
    func testSave() {
        let soundwich = generateSoundwich()
        
        let expectation = expectationWithDescription("Save")
        waitForExpectationsWithTimeout(10) { error in
            
            SoundwichStore.add(soundwich) { (saved, error) in
                XCTAssertEqual(error, nil)
                XCTAssertNotEqual(soundwich.id, nil)
            
                expectation.fulfill()
            }
        }
    }
    
    func generateSoundwich() -> Soundwich {
        return Soundwich(title: "test 1")
    }
}
