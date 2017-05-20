//
//  ViewController.swift
//  News
//
//  Created by Yermakov Anton on 07.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    var articles : [Articles]? = []
    var source = "techcrunch"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        fetchArticles(from: source)
    
    }
    
    func fetchArticles(from provider: String){
        
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=\(provider)&sortBy=top&apiKey=cef6b1333e144d749dddfe849596b11d")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print("error")
            }
            
            self.articles = [Articles]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]]{
                    for articleFromJson in articlesFromJson {
                        
                        let article = Articles()
                        
                        if let author = articleFromJson["author"] as? String, let title = articleFromJson["title"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String{
                            
                            article.author = author
                            article.title = title
                            article.desc = desc
                            article.url = url
                            article.imageURL = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                    
                }
            }catch {
                print("error")
            }
        }
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.myTitle.text = articles?[indexPath.item].title
        cell.myDescription.text = articles?[indexPath.item].desc
        cell.myAuthor.text = articles?[indexPath.item].author
        cell.myImage.downloadImage(from: (articles?[indexPath.item].imageURL)!)
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    let menuManager = MenuManager()
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
        self.menuManager.openMenu()
        menuManager.mainVC = self 
    }
    
}

extension UIImageView{
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}






