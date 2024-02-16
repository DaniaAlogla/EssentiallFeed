//
//  LocalFeedItem.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 06/08/1445 AH.
//

import Foundation

public struct LocalFeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
