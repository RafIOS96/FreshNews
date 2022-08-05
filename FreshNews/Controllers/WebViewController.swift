//
//  WebViewController.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 05.08.22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    private var webView: WKWebView!
    private var loadInd: UIActivityIndicatorView!
    public var isFromSubaView: Bool = false
    public var url: String!
    public var pageTitle: String!
    public var needRegisterMoveParty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.creatView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.topItem?.title = pageTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        
        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backBarBtnItem
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        PopUpMsgManager.shared.hideNotification()
        if isFromSubaView {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    private func creatView()  {
        
        self.view.backgroundColor = .white
        
        webView = WKWebView(frame: CGRect(x: 0, y: topbarHeight, width: self.view.frame.width, height: self.view.frame.height - topbarHeight))
        webView.load(URLRequest(url: URL(string: self.url)!))
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        loadInd = UIActivityIndicatorView(style: .large)
        loadInd.color = .lightGray
        loadInd.frame.origin = CGPoint(x: self.view.frame.width/2 - loadInd.frame.width/2, y: (webView.frame.minY + webView.frame.height/2) - loadInd.frame.height/2)
        loadInd.startAnimating()
        self.view.addSubview(loadInd)
    }
    
    private func showLoadInd() {
        UIView.animate(withDuration: 0.1) {
            self.loadInd.alpha = 1
        }
    }
    
    private func hideLoadInd() {
        UIView.animate(withDuration: 0.1) {
            self.loadInd.alpha = 0
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoadInd()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.popUpWarning(text: error.localizedDescription)
        self.hideLoadInd()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.popUpWarning(text: error.localizedDescription)
        self.hideLoadInd()
    }
    
    private func popUpWarning(text: String) {
        DispatchQueue.main.async {
            let origin = UIScreen.main.bounds.height - self.getSafeAreaHeight(top: false)
            PopUpMsgManager.shared.addMsg(text: text, originY: origin)
        }
    }
}
