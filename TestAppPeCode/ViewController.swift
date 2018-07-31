//
//  ViewController.swift
//  TestAppPeCode
//
//  Created by Валерий Мельников on 26.04.18.
//  Copyright © 2018 Валерий Мельников. All rights reserved.
//

import UIKit
import SafariServices
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var menubtn: UIBarButtonItem!
    @IBOutlet weak var searchingBar: UISearchBar!
    var filteredData = [String]()
    var DataSearch : NSMutableArray = []
    var DataArticles : NSMutableArray = []
    var isSearching = false
    @IBOutlet weak var tableview: UITableView!
    var articles : [Article]? = []
    var pagination :Int  = 0
    let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=fa593b678cd8489dbe12a33dcc1fac3b")!)
    lazy var refreshControl:UIRefreshControl =
        {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(ViewController.actualData(_:)), for: .valueChanged)
            refreshControl.tintColor = UIColor.white
            return refreshControl
            
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil
        {
            menubtn.target = self.revealViewController()
            menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.tableview.addSubview(self.refreshControl)
        tableview.delegate = self
        tableview.dataSource = self
        searchingBar.delegate = self
        searchingBar.returnKeyType = UIReturnKeyType.done
        ConnectService(urlRequest: urlRequest)
        
    }

    @objc func actualData(_ refreshControl:UIRefreshControl)
    {
        self.articles?.removeAll()
        ConnectService(urlRequest: urlRequest)
        self.tableview.reloadData()
        refreshControl.endRefreshing()
    }
    func ConnectService(urlRequest : URLRequest)
    {
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
                        self.ReloadData()
                    }
                }catch{
                    print("Json Error")
                }
                
            }
            
        }.resume()
    }
    
   func ReloadData()
    {
        if(self.tableview != nil)
        {
            self.tableview.reloadData()
        }
        
        
    }

     func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
         cell.title.text = self.articles?[indexPath.item].headline
         cell.desc.text = self.articles?[indexPath.item].desc
         cell.author.text = self.articles?[indexPath.item].author
      
          cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
        return cell
    }
    
    
    func numberOfSections(in tableView:UITableView)-> Int
    {
        return 1
    }


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isSearching{
                return DataSearch.count
            }
            return self.articles?.count ?? 0
        }
      
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let image = self.articles?[indexPath.item].url {
            let url = URL(string: image)
            let safari = SFSafariViewController(url: url!)
            present(safari, animated: true, completion: nil)
            
            
            
    }
}
    func showAlertButtonTapped() {
        
        // create the alert
        let alert = UIAlertController(title: "Sorry", message: "No work", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
           tableview.reloadData()
        } else
        {
            isSearching = true
            if (DataArticles.count <= 0 )
            {   tableview.reloadData()
                showAlertButtonTapped()
                return
            }
            
            var text : String
            text = (searchBar.text?.lowercased())!
            self.DataSearch = []
            for temps in DataArticles
            {
                 let art = temps as? Article
                if ((art?.author?.lowercased().range(of: text)) != nil) || ((art?.desc?.lowercased().range(of: text)) != nil) || ((art?.headline?.lowercased().range(of: text)) != nil)
                {
                   
                    self.DataSearch.add(art)
                   
                    
                }
            }
            if(DataSearch.count > 0 )
            {
                self.articles = DataSearch as! [Article]
                tableview.reloadData()
            }
            
           
            
        }
       
    }

    
}
extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        var task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}


