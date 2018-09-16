//
//  FlickrImgCell.swift
//  EnAnek
//
//  Created by online on 16/09/18.
//  Copyright © 2018 online. All rights reserved.
//

import UIKit

class FlickrImgCell: UICollectionViewCell {
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView() {
        addSubview(thumbImageView)
        thumbImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        thumbImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        thumbImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
}
