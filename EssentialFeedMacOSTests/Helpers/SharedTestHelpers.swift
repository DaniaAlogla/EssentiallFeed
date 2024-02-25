//
//  SharedTestHelpers.swift
//  EssentialFeedMacOSTests
//
//  Created by Dania Alogla on 15/08/1445 AH.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
