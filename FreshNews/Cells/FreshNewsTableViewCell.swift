//
//  FreshNewsTableViewCell.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 04.08.22.
//

import UIKit

class FreshNewsTableViewCell: UITableViewCell {

    var newsTitleLbl: UILabel!
    var thumbImgView: UIImageView!
    var shortDescriptionLbl: UILabel!
    var loadInd: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadInd = UIActivityIndicatorView(style: .medium)
        self.loadInd.color = .darkGray
        self.loadInd.startAnimating()
        contentView.addSubview(loadInd)
        
        self.newsTitleLbl = UILabel()
        self.newsTitleLbl.textAlignment = .left
        self.newsTitleLbl.textColor = .systemBlue
        self.newsTitleLbl.font = UIFont.boldSystemFont(ofSize: 14)
        self.newsTitleLbl.numberOfLines = 0
        contentView.addSubview(self.newsTitleLbl)
        
        self.thumbImgView = UIImageView()
        self.thumbImgView.contentMode = .scaleAspectFit
        contentView.addSubview(self.thumbImgView)
        
        self.shortDescriptionLbl = UILabel()
        self.shortDescriptionLbl.textAlignment = .center
        self.shortDescriptionLbl.textColor = .black
        self.shortDescriptionLbl.font = UIFont.systemFont(ofSize: 12)
        self.shortDescriptionLbl.numberOfLines = 0
        contentView.addSubview(self.shortDescriptionLbl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellWidth = self.frame.width
        let cellHeight = self.frame.height
        let leftMargin: CGFloat = 16
        let topMargin: CGFloat = 16
        let betweenSpacing: CGFloat = 16
        let titleLblHeight: CGFloat = 60
        
        self.thumbImgView.frame = CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight)
        self.newsTitleLbl.frame = CGRect(x: thumbImgView.frame.maxX + betweenSpacing, y: topMargin, width: cellWidth - thumbImgView.frame.maxX - leftMargin, height: titleLblHeight)
        self.shortDescriptionLbl.frame = CGRect(x: thumbImgView.frame.maxX + betweenSpacing, y: newsTitleLbl.frame.maxY + betweenSpacing, width: newsTitleLbl.frame.width, height: cellHeight - newsTitleLbl.frame.maxY - betweenSpacing)
        self.loadInd.frame.origin = CGPoint(x: self.thumbImgView.frame.minX + (self.thumbImgView.frame.width/2 - self.loadInd.frame.width/2), y: self.thumbImgView.frame.minY + (self.thumbImgView.frame.height/2 - self.loadInd.frame.height/2))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
