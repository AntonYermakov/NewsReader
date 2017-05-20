//
//  WebViewController.swift
//  News
//
//  Created by Yermakov Anton on 08.05.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }


}
