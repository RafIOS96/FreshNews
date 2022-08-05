//
//  FreshNewsApiCall.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 04.08.22.
//

import SWXMLHash
import Alamofire
import Foundation

class FreshNewsApiCall {
    
    static let shared = FreshNewsApiCall()
        
    private let url: String = URLEnum.jsonNewsUrl.rawValue
    
    func getFreshNewsApiCall(
         onSuccess: @escaping(_ result: [NSDictionary]?) -> Void,
         onFailed: @escaping(_ failed: String) -> Void) {
            
         AF.request(url, method: .get).responseJSON { response in
            switch response.result
            {
            case .success(let data):
                print("a")
                let result_info: [String:Any] = data as? [String:Any] ?? [:]
                let articles_dict = result_info["articles"] as? [NSDictionary]
                if articles_dict != nil {
                    onSuccess(articles_dict)
                } else {
                    onFailed(ErrorType.noData.rawValue)
                }
            case .failure(let error):
                onFailed(error.localizedDescription)
            }
        }
    }
    
    func getFreshNewsXMLApiCall(
         onSuccess: @escaping(_ result: XMLIndexer?) -> Void,
         onFailed: @escaping(_ failed: String) -> Void) {

         let url = NSURL(string: URLEnum.xmlNewsUrl.rawValue)

         let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
             
            if error != nil {
                onFailed(error!.localizedDescription)
                return
            }
             
            if data != nil
            {
                let feed=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let xml = SWXMLHash.parse(feed)
                
                onSuccess(xml)

            } else {
                onFailed(ErrorType.noData.rawValue)
            }
        }
        task.resume()
    }
}

