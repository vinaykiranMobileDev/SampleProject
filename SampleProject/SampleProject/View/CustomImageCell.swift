//
//  CustomImageCell.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation
import UIKit

class CustomImageCell: UITableViewCell {
    //MARK:- Lazy Variables
    private var cellImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 13
        img.clipsToBounds = true
        return img
    }()
    
    private var titleLable:UILabel = {
        let alable = UILabel()
        alable.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        alable.numberOfLines = 0
        return alable
    }()
    
    private var detailsLable:UILabel = {
        let alable = UILabel()
        alable.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
        alable.numberOfLines = 0
        return alable
    }()
    
    //MARK:-  Variables
    var cellData: CellInfo?
    private var networkMangaer:NetworkManager? = NetworkManager()
    let aTitleFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
    let aSubtitleFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
    
    private var kPadding:CGFloat = 10.0
    
    //MARK:- Init functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        networkMangaer?.delegate = self
        self.addSubview(cellImage)
        self.addSubview(titleLable)
        self.addSubview(detailsLable)
        cellData = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageYPos = self.bounds.height/2 - 50
        cellImage.frame = CGRect(x:kPadding , y: imageYPos , width: 150, height: 100)
        cellImage.backgroundColor = UIColor.blue
        
        let xPos = cellImage.bounds.width + (2 * kPadding)
        
        let labelWidth = self.frame.width - (cellImage.bounds.width + (3 * kPadding))
        
        var titleHeight = (cellData?.title ?? "").sizeOfString(aTitleFont, constrainedToWidth: labelWidth).height
        
        if titleHeight < 40 {
            titleHeight = 40
        }
        titleLable.frame = CGRect(x: xPos, y: 10, width: labelWidth, height: titleHeight)
        
        let detailText = cellData?.description ?? ""
        let detailslabelHeight = detailText.sizeOfString(aSubtitleFont,
                                                         constrainedToWidth: labelWidth).height
        detailsLable.frame = CGRect(x: xPos, y: titleHeight + (2 * kPadding),
                                             width: labelWidth,
                                             height: detailslabelHeight)
    }
    
    //MARK:- Custom functions
    func configureCelll() {
        detailsLable.text = cellData?.description ?? ""
        titleLable.text = cellData?.title ?? ""
        DispatchQueue.main.async {
            if let aImage = self.cellData?.image {
                self.cellImage.image = aImage
            } else{
                self.cellImage.image = UIImage(named: "NoPreview")
                self.getImage()
            }
        }
    }
    
    func getImage() {
        guard let imageURL = cellData?.imageURL  else{
            return
        }
        
        self.networkMangaer?.downloadImageFrom(imageURL)
    }
}

//MARK:- APICallBack
extension CustomImageCell :APICallBack {
    func onData(_ info: Any?) {
        if let aImageData = info as? [String: Any] {
            if let aImage = aImageData["image"] as? UIImage {
                DispatchQueue.main.async {
                    self.cellImage.image = aImage
                    self.cellData?.image = aImage
                    print("Imaged Loaded")
                }
            }            
        }
    }
    
    func onError(_ error: String) {
        print(error)
    }
}
