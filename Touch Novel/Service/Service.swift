//
//  NetworkManager.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Service
{
    static let shared: Service = Service()
    
    private init() {}
    
    func fetchData(section: Int, handle: @escaping ([DataModel.Novel]?) -> Void)
    {
        //MARK: - Alamofire -> webservice -> get
        guard let url = AppConstants.Network.urls[section] else { return }
        let header: HTTPHeaders = [.accept(AppConstants.Network.header)]
        AF.request(url, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let json = JSON(response.value!)
                let novelList = self.loadDataSourceWithJSONData(json)
                handle(novelList)
            case .failure(_):
                print(response.error!.localizedDescription)
            }
        }
    }
    
    private func loadDataSourceWithJSONData(_ json: JSON) -> [DataModel.Novel]
    {
        var bookList = [DataModel.Novel]()
        let JSONKeys = AppConstants.Network.JSONKeys.self
        guard let arrayOfNovels = json[JSONKeys.items].array else { return bookList}
        
        for aNovel in arrayOfNovels
        {
            let volInfo = aNovel[JSONKeys.volumeInfo]
            let title = volInfo[JSONKeys.title].stringValue
            var authors = ""
            guard let authorsList = volInfo[JSONKeys.authors].array else { return bookList}
            for author in authorsList
            {
                authors.append("\(author.stringValue) ")
            }
            let thumbnail = volInfo[JSONKeys.imageLinks][JSONKeys.small].stringValue
            
            let novel = DataModel.Novel(title: title,
                                        author: authors,
                                        imageUrl: URL(string: thumbnail))
            
            bookList.append(novel)
        }
        
        return bookList
    }
    
    
}

