//
//  Connetions.swift
//  TestAppPeCode
//
//  Created by Валерий Мельников on 29.04.18.
//  Copyright © 2018 Валерий Мельников. All rights reserved.
//

import UIKit

class Connetions {
  /*   var articles : [Article]? = []
    let conn =  ViewController()
    func ConnectService()
    {
         let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/everything?q=apple&from=2018-05-01&to=2018-05-01&sortBy=popularity&apiKey=fa593b678cd8489dbe12a33dcc1fac3b")!)
        URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error == nil
            {
                self.articles = [Article]()
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    if let newsFromJson = json["articles"] as? [[String : AnyObject]]
                    {
                        for newFromJson in newsFromJson
                        { let article = Article()
                            if let title = newFromJson["title"] as? String,let author = newFromJson["author"] as? String, let desc = newFromJson["description"] as? String,let url = newFromJson["url"] as? String,let imageToUrl =  newFromJson["urlToImage"]as? String
                            {
                                
                                article.author = author
                                article.desc = desc
                                article.headline = title
                                article.url = url
                                article.imageUrl = imageToUrl
                            }
                            self.articles?.append(article)
                        }
                    }
                    DispatchQueue.main.async {
                        self.conn.ReloadData()
                    }
                }catch{
                    print("Json Error")
                }
                
            }
            
            }.resume()
    }*/
}
