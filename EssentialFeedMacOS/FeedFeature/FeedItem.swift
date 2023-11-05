//
//  FeedItem.swift
//  
//
//  Created by Dania Alogla on 01/03/1445 AH.
//

import Foundation

public struct FeedItem: Equatable{
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
