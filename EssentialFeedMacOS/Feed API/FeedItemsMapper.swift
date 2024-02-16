//
//  FeedItemsMapper.swift
//  EssentialFeedMacOS
//
//  Created by Dania Alogla on 02/05/1445 AH.
//

import Foundation

internal final  class FeedItemMapper {
    
    private static var OK_200 : Int {
        return 200
    }
    
    private struct Root: Decodable{
        let items: [RemoteFeedItem]
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200 ,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items

    }
}
