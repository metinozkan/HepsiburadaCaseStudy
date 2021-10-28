//
//  Service.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import Foundation
import Alamofire



import Alamofire

class Service {
    func getData(term: String,skip: Int,entity: String, callback: @escaping ([Result]?) -> Void) {
        let limit = 20
        let header : HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"*/*"]
        
        
        AF.request(Constants.mainUrl + "term=\(term)&limit=\(limit*skip)&entity=\(entity)", method: .get,encoding: JSONEncoding.default,headers: header).responseJSON { response in
            
            guard let data = response.data else{return}
            do {
                let itemResponse = try JSONDecoder().decode(allSearch.self, from:data)
                callback(itemResponse.results)
            } catch let e {
                print(e)
            }
        }
       
     
    }
}
