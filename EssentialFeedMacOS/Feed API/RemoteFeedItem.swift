//
//  RemoteFeedItem.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 06/08/1445 AH.
//

import Foundation

internal struct RemoteFeedItem: Decodable{
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
