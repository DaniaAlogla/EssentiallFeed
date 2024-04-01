//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Dania Alogla on 07/06/1445 AH.
//

import XCTest


extension XCTestCase{
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line){
        addTeardownBlock{ [weak instance ] in
           XCTAssertNil(instance, "instance should have been deallocated. Potential memory leak.", file: file , line: line)
        }
    }
}
