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
        waitForExpectationsWithTimeout(5) { error in
            
            SoundwichStore.update(soundwich)
//            SoundwichStore.add(soundwich) { saved in
//                XCTAssert(soundwich.id != nil)
//                
                expectation.fulfill()
//            }
            
        }
        
    }
    
    func generateSoundwich() -> Soundwich {
        return Soundwich(title: "test 1")
    }
}
