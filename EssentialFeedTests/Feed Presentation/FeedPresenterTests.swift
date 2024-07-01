//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Dania Alogla on 25/12/1445 AH.
//

import XCTest

final class FeedPresenter {
    init(view: Any){
        
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        var messages = [Any]()
    }
}
