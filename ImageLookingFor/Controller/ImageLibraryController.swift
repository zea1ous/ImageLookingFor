//
//  ImageLibraryController.swift
//  ImageLookingFor
//
//  Created by Alexander Kolovatov on 15.01.18.
//  Copyright © 2018 Alexander Kolovatov. All rights reserved.
//

import UIKit

class ImageLibraryController: UIViewController {

    private let cellId = "cellId"
    private var imageCollection: [Image] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let toolBarView: UIToolbar = {
        let tb = UIToolbar()
        tb.isTranslucent = false
        tb.barTintColor = UIColor.RedTheme.scarlet
        tb.tintColor = .white
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupToolBarButtons()
        
        //FIXME: Replace temporary data to saved data from device
        let firstImage = Image()
        firstImage.thumbnailImageName = "motivation"
        let secondImage = Image()
        secondImage.thumbnailImageName = "second"
        imageCollection = [firstImage, secondImage]
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        view.addSubview(toolBarView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: toolBarView)
        view.addConstraintsWithFormat(format: "V:[v0(40)]|", views: toolBarView)
    }
    
    private func setupToolBarButtons() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items: [UIBarButtonItem] = [saveBarButton, space, deleteBarButton]
        toolBarView.items = items
    }
    
    @objc private func saveButtonPressed() {
        print("save")
    }
    
    @objc private func deleteButtonPressed() {
        print("delete")
    }
}

extension ImageLibraryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User did Select item \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("User did Deselect item \(indexPath)")
    }
}

extension ImageLibraryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ImageLibraryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.image = imageCollection[indexPath.item]
        return cell
    }
}
