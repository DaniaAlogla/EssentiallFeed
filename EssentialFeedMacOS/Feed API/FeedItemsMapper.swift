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
        let items: [Item]
        
        var feed: [FeedItem]{
            return items.map{ $0.item }
        }
    }

    private struct Item: Decodable{
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }

    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200 ,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(.invalidData)
        }
        let items =  root.feed
        return .success(items)

    }
}
