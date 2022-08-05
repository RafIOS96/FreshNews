//
//  Enums.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 05.08.22.
//

import Foundation

enum ErrorType: String, CaseIterable {
    case noInternet = "No Internet Connection"
    case noData = "No data"
}

enum EncodedObjectsKeys: String, CaseIterable {
    case freshNewsModel = "freshNewsModel"
}

enum URLEnum: String, CaseIterable {
    case jsonNewsUrl = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=97ba815035ae4381b223377b2df975ab"
    case xmlNewsUrl = "http://feeds.bbci.co.uk/news/video_and_audio/technology/rss.xml"
}
