//
//  FreshNewsViewController.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 04.08.22.
//

import UIKit
import Kingfisher

class FreshNewsViewController: UIViewController {
    
    private let screenSize: CGRect = UIScreen.main.bounds
    private var freshNewsTableView: UITableView!
    private var freshNewsModel = [FreshNewsModel]()
    private var freshNewsModelFromXML = [FreshNewsModelXML]()

    override func viewDidLoad() {
        super.viewDidLoad()

//      self.getFreshNewsFromXML()
        self.getFreshNews()
    }
    
    private func getFreshNewsFromXML() {
        FreshNewsDataManager.shared.getFreshNewsByXML { result in
            self.freshNewsModelFromXML = result!
        } onFailed: { failed in
            self.showAlertBanner(txt: failed)
        }
    }
    
    private func getFreshNews() {
        FreshNewsDataManager.shared.getFreshNews { result in
            self.freshNewsModel = result!
            self.createView()
        } onFailed: { failed in
            self.createView()
        }
    }
    
    private func showAlertBanner(txt: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            PopUpMsgManager.shared.addMsg(text: txt, originY: UIScreen.main.bounds.height - self.getSafeAreaHeight(top: false))
        }
    }
    
    private func createView() {
        self.createNavBar()
    }
    
    private func createNavBar() {
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: getSafeAreaHeight(top: true),
                                                   width: view.frame.size.width, height: 44))
        navBar.barTintColor = UIColor.white
        self.view.addSubview(navBar)

        let navItem = UINavigationItem(title: "News")
        navBar.setItems([navItem], animated: false)
        
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnDidTapped))
         navigationItem.rightBarButtonItem = saveBtn
        
        self.createTableView(minY: navBar.frame.maxY)
    }
    
    @objc func saveBtnDidTapped() {
        let alert = UIAlertController(title: "Alert", message: "Do you want to store data localy?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            UserDefaultsManager.shared.setEncodedObject(object: self.freshNewsModel, forKey: .freshNewsModel)
        }))
        alert.addAction((UIAlertAction(title: "No", style: .cancel)))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createTableView(minY: CGFloat) {
        let minYTableView = minY + 10
        let tableViewHeight = self.screenSize.height - minYTableView - getSafeAreaHeight(top: false)
        self.freshNewsTableView = UITableView(frame: CGRect(x: 0, y: minYTableView, width: self.screenSize.width, height: tableViewHeight))
        self.freshNewsTableView.register(FreshNewsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.freshNewsTableView.rowHeight = 180
        self.freshNewsTableView.delegate = self
        self.freshNewsTableView.dataSource = self
        self.freshNewsTableView.separatorStyle = .none
        self.view.addSubview(self.freshNewsTableView)
    }
    
    private func checkInternet() {
        if !Reachability.isConnectedToNetwork() {
            self.showAlertBanner(txt: ErrorType.noInternet.rawValue)
        }
    }
}

extension FreshNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.freshNewsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FreshNewsTableViewCell
        let currentNewsModel: FreshNewsModel = self.freshNewsModel[indexPath.row]
        let imgThumbUrl = URL(string: currentNewsModel.urlToImage!)
        cell.newsTitleLbl.text = currentNewsModel.title
        cell.shortDescriptionLbl.text = currentNewsModel.content
        cell.thumbImgView.kf.setImage(with: imgThumbUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerID") as! WebViewController
        vc.url = URLEnum.xmlNewsUrl.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkInternet()
    }
}
