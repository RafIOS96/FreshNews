//
//  FreshNewsDataManager.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 04.08.22.
//

import SWXMLHash
import Foundation
import Kingfisher

class FreshNewsDataManager {
    
    static let shared = FreshNewsDataManager()
    
    func getFreshNews(
         onSuccess: @escaping(_ result: [FreshNewsModel]?) -> Void,
         onFailed: @escaping(_ failed: String) -> Void) {
             if !Reachability.isConnectedToNetwork() {
                 let localSavedNews = self.getFreshNewsFromLocalStorage()
                 if localSavedNews.count > 0 {
                     onSuccess(localSavedNews)
                 } else {
                     onFailed(ErrorType.noInternet.rawValue)
                 }
             } else {
                 FreshNewsApiCall.shared.getFreshNewsApiCall { result in
                     onSuccess(self.parseObject(objectList: result!))
                 } onFailed: { failed in
                     onFailed(failed)
                 }
             }
    }
    
    func getFreshNewsByXML(
         onSuccess: @escaping(_ result: [FreshNewsModelXML]?) -> Void,
         onFailed: @escaping(_ failed: String) -> Void) {
            FreshNewsApiCall.shared.getFreshNewsXMLApiCall { result in
                onSuccess(self.parseXMLObject(xml: result!))
            } onFailed: { failed in
                onFailed(failed)
            }
    }
    
    private func getFreshNewsFromLocalStorage() -> [FreshNewsModel] {
        var orders = [FreshNewsModel]()
        if let object = UserDefaultsManager.shared.getEncodedObject(forKey: .freshNewsModel) {
            orders = object as! [FreshNewsModel]
        }
        return orders
    }
    
    private func parseXMLObject(xml: XMLIndexer) -> [FreshNewsModelXML]{
        var newsItems = [FreshNewsModelXML]()

        for elem in xml["rss"]["channel"]["item"].all
        {
            let item = FreshNewsModelXML()
            item.title = elem["title"].element!.text
            item.url = elem["link"].element!.text
            item.pubDate = elem["pubDate"].element?.text
            newsItems.append(item)
        }
        
        return newsItems
    }
    
    private func parseObject(objectList: [NSDictionary]) -> [FreshNewsModel] {
        var newsModel = [FreshNewsModel]()
        let imgView = UIImageView()
        for i in 0..<objectList.count {
            newsModel.append(FreshNewsModel.init(newsDict: objectList[i]))
            imgView.kf.setImage(with: URL(string:newsModel[i].urlToImage!))
        }
        newsModel.sort(by: { $0.publishedAt?.compare($1.publishedAt!) == .orderedDescending })
        return newsModel
    }
}

