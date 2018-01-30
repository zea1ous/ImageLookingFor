//
//  ImageCell.swift
//  ImageLookingFor
//
//  Created by Alexander Kolovatov on 07.01.18.
//  Copyright © 2018 Alexander Kolovatov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var checkmarkView: CheckMark!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.thumbnailImageView.alpha = 0.7
                checkmarkView.checked = true
            } else {
                self.thumbnailImageView.alpha = 1
                checkmarkView.checked = false
            }
        }
    }
    
    var image: Image? {
        didSet {
            if let image = image?.thumbnailImageName {
                thumbnailImageView.image = UIImage(named: image)
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func setupViews() {
        addSubview(thumbnailImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailImageView)
        checkmarkView = CheckMark(frame: CGRect(x: frame.width-30, y: frame.height-30, width: 30, height: 30))
        checkmarkView.backgroundColor = UIColor.clear
        thumbnailImageView.addSubview(checkmarkView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

