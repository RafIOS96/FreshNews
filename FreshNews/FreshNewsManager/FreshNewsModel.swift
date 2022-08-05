//
//  FreshNewsModel.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 04.08.22.
//

import Foundation

// Model for JSON
class FreshNewsModel: Codable {
    var source: SourceModel?
    var author: String?
    var urlToImage: String?
    var content: String?
    var title: String?
    var publishedAt: Date?
    var description: String?
    var url: String?
    
    init(newsDict: NSDictionary) {
        self.source = SourceModel.init(sourceDict: newsDict)
        self.author = newsDict["author"] as? String
        self.urlToImage = newsDict["urlToImage"] as? String
        self.content = newsDict["content"] as? String
        self.title = newsDict["title"] as? String
        self.publishedAt = Helper.shared.getDate(txt: newsDict["publishedAt"] as? String ?? "")
        self.description = newsDict["description"] as? String
        self.url = newsDict["url"] as? String
    }
}

class SourceModel: Codable {
    var id: String?
    var name: String?
    
    init(sourceDict: NSDictionary) {
        self.id = sourceDict["id"] as? String
        self.name = sourceDict["name"] as? String
    }
}

// Model for XML
class FreshNewsModelXML: Identifiable
{
    var title: String?
    var url: String?
    var pubDate: String?
}

