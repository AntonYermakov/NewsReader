//
//  MenuManager.swift
//  News
//
//  Created by Yermakov Anton on 08.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let blackView = UIView()
   
    var arrayOfSourses = ["TechCrunch", "TechRadar"]
    let menuTableView = UITableView()
    var mainVC: ViewController?
   
    
    public func openMenu(){
        
        if let window = UIApplication.shared.keyWindow{
            
            self.blackView.frame = window.frame
            self.blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            self.blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu)))
            
            let height : CGFloat = 100
            let y = window.frame.height - height
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            window.addSubview(blackView)
            window.addSubview(menuTableView)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blackView.alpha = 1
                self.menuTableView.frame.origin.y = y
            })
        }
    }
    
    public func dismissMenu(){
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.menuTableView.frame.origin.y = window.frame.height
            }
        })
    }
    
    override init(){
        super.init()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        menuTableView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
        cell.textLabel?.text = arrayOfSourses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC{
            vc.source = arrayOfSourses[indexPath.item].lowercased()
            vc.fetchArticles(from: arrayOfSourses[indexPath.item].lowercased()) 
        }
    }
    
}





