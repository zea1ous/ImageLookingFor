//
//  ViewController.swift
//  ImageLookingFor
//
//  Created by Alexander Kolovatov on 06.01.18.
//  Copyright © 2018 Alexander Kolovatov. All rights reserved.
//

import UIKit

class SearchController: UICollectionViewController {

    private var searches: [FlickrSearchResults] = []
    private var selectedCellsArray: [IndexPath] = []
    fileprivate let flickr = Flickr()
    fileprivate let cellId = "cellId"
    fileprivate let blackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGesture()
        setupUI()
        setupNavBarButtons()
        textField.delegate = self
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.allowsMultipleSelection = true
    }

    let textField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .search
        textField.placeholder = "Search"
        return textField
    }()
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private func setupSearchBar() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 54).isActive = true
        textField.alpha = 0
        textField.backgroundColor = .white
        textField.becomeFirstResponder()
    }
    
    private func setupUI() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        collectionView?.backgroundColor = .white
        navigationItem.titleView = titleLabel
    }
    
    private func setupNavBarButtons() {
        let saveBarButtonImage = UIImage(named: "saveArrow")
        let saveBarButtonItem = UIBarButtonItem(image: saveBarButtonImage, style: .plain, target: self, action: #selector(saveButtonPressed))
        let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        let imagesBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(collectionButtonPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [space, searchBarButtonItem]
        navigationItem.rightBarButtonItems = [saveBarButtonItem, imagesBarButtonItem]
    }
    
    private func setupGesture() {
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapTriggered))
        doubleTap.numberOfTapsRequired = 2
        collectionView?.addGestureRecognizer(doubleTap)
    }
    
    @objc private func doubleTapTriggered(gesture: UITapGestureRecognizer) {
        let point: CGPoint = gesture.location(in: self.collectionView)
        
        if let selectedIndexPath: IndexPath = collectionView?.indexPathForItem(at: point) {
            let selectedCell: UICollectionViewCell = collectionView!.cellForItem(at: selectedIndexPath as IndexPath)!
            
            print("cell \(selectedCell) was double tapped")
            
            // TODO: Animation like as iOS photo library
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.collectionView?.alpha = 0
            }, completion: nil)
            
            if let window = UIApplication.shared.keyWindow {
                window.addSubview(mainScrollView)
                mainScrollView.frame = window.frame
                mainScrollView.alpha = 1
                
                let resultsArray = getSearchResultsArray()
                
                print(selectedIndexPath.row)
                
                // FIXME: Set preview to get a correct cell
                
                for i in 0..<resultsArray.count {
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = resultsArray[i]
                    
                    let xPosition = self.view.frame.width * CGFloat(i)
                    imageView.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    
                    mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
                    mainScrollView.addSubview(imageView)
                }
                
                let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(downSwipeTriggered))
                swipeDown.direction = UISwipeGestureRecognizerDirection.down
                window.addGestureRecognizer(swipeDown)
            }
        }
    }
    
    private func getSearchResultsArray() -> [UIImage] {
        let searchesResultArray: [FlickrSearchResults] = searches
        var resultsArray: [UIImage] = []
        
        for value in searchesResultArray {
            for image in value.searchResults {
                resultsArray.append(image.thumbnail!)
            }
        }
        return resultsArray
    }
    
    @objc private func searchButtonPressed() {
        print("Search button has pressed")
        showSearchBar()
    }
    
    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.textField.alpha = 0
            self.textField.text = ""
            self.blackView.alpha = 0
        })
        
        if let window = UIApplication.shared.keyWindow {
                window.endEditing(true)
        }
    }
    
    @objc private func saveButtonPressed() {
        print("Save button has pressed")
        // TODO: Add implementation to save to directory on device
    }
    
    @objc private func collectionButtonPressed() {
        print("Image collection button has pressed")
        let imageLibraryController = ImageLibraryController()
        self.navigationController?.pushViewController(imageLibraryController, animated: true)
    }
    
    @objc private func downSwipeTriggered() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mainScrollView.alpha = 0
            self.collectionView?.alpha = 1
        })

        if let window = UIApplication.shared.keyWindow {
            self.collectionView?.frame = window.frame
        }
        
        print("Swipe down gesture")
    }

    private func showSearchBar() {

        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            window.addSubview(blackView)
            window.addSubview(textField)

            self.setupSearchBar()

            blackView.frame = window.frame
            blackView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.textField.alpha = 1
            }, completion: nil)
        }
    }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell:ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        cell.thumbnailImageView.image = flickrPhoto.thumbnail
        cell.checkmarkView.checked = cell.isSelected
        
        return cell
    }
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Array of selected indexes for saving to device
        selectedCellsArray = collectionView.indexPathsForSelectedItems!
        print(indexPath.row)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("User did Deselect \(indexPath.row)")
    }

}

private extension SearchController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as IndexPath).row]
    }
}

extension SearchController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickrForTerm(textField.text!) {
            results, error in

            activityIndicator.removeFromSuperview()
            
            if let error = error {
                print("Error searching: \(error)")
                return
            }
            
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                self.collectionView?.reloadData()
                self.handleDismiss()
            }
        }
        return true
    }
}
