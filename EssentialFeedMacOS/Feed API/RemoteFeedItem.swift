//
//  RemoteFeedItem.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 06/08/1445 AH.
//

import Foundation

 struct RemoteFeedItem: Decodable{
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
