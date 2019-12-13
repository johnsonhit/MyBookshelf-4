//
//  CollectionViewControllerExtension.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 13/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

extension UICollectionView {

    func setBackgroundView(idiom: String = "No result") {
        
        let view = UIView()
        view.frame = self.bounds
        
        let label = UILabel()
        view.backgroundColor = .white
        view.addSubview(label)
        
        _ = label.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        label.contentMode = .scaleAspectFit
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.text = idiom
        
        self.backgroundView = view
    }
    
}
