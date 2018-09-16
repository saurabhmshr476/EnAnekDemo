//
//  ViewController.swift
//  EnAnek
//
//  Created by online on 16/09/18.
//  Copyright © 2018 online. All rights reserved.
//

import UIKit
import SDWebImage
import SimpleImageViewer
import CRNotifications
class ViewController: UICollectionViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //let customNavigationAnimationController = CustomNavigationAnimatorController()
    var selectedIndexPath: IndexPath!
    private var searchTxt = ""
    private var waiting = false;
    private var searches = [FlickrSearchResults]()
    private let flickr = FlickrHelper()
    lazy var searchBar = UISearchBar(frame: .zero)
    lazy var barBtn = UIBarButtonItem(title: "Option", style: .plain, target: self, action: #selector(changeTapped))
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 40.0, right: 10.0)
    private var itemsPerRow: CGFloat = 2{
        didSet {
            self.collectionView?.reloadData()
        }
    }
    let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        
    }

    func setUp(){
        view.addSubview(spinner)
        spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spinner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = barBtn
        searchBar.placeholder = "Search"
        view.backgroundColor = .white
        collectionView?.register(FlickrImgCell.self, forCellWithReuseIdentifier: "CellID")
        activityIndicator.hidesWhenStopped = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {

        searchBar.resignFirstResponder()
    }

    
    

    

    
    
    // MARK: - Photo URL String for IndexPath
    func photoForIndexPath(_ indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
    
    // MARK: - LoadPaging Data
    func loadMoreData(){
        let pageCounter = flickr.pageCounter() + 1
        flickr.setPageCounter(counter: pageCounter)
        flickr.searchFlickrForTerm(searchBar.text!) {
            results, error in
            self.spinner.stopAnimating()
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm) page \(pageCounter)")
                self.searches[0].searchResults.append(contentsOf: results.searchResults)
                self.collectionView?.reloadData()
                if(results.searchResults.count>0){
                    self.waiting = false;
                    
                }
            }
        }
    }
    
    // MARK: - ActionSheet Opens
    @objc func changeTapped(sender: UIBarButtonItem) {

        // MARK: - ActionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)

        // 1 - 2 item per row
        let twoItemActionButton = UIAlertAction(title: "2 item per row", style: .default) { _ in
            print("2 item per row")
            self.itemsPerRow = 2
        }
        actionSheetController.addAction(twoItemActionButton)
        
        // 2 - 3 item per row
        let threeItemActionButton = UIAlertAction(title: "3 item per row", style: .default)
        { _ in
            print("3 item per row")
            self.itemsPerRow = 3
        }
        // 3 - 4 item per row
        actionSheetController.addAction(threeItemActionButton)
        let fourItemActionButton = UIAlertAction(title: "4 item per row", style: .default)
        { _ in
            print("4 item per row")
            self.itemsPerRow = 4
        }
        // 4 - cancel
        actionSheetController.addAction(fourItemActionButton)
        let deleteActionButton = UIAlertAction(title: "cancel", style: .cancel)
        { _ in
            print("cancel")
            
        }
        actionSheetController.addAction(deleteActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}



// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        searchBar.resignFirstResponder()
        searchTxt = searchBar.text!
        
        
        if !Connectivity.isConnectedToInternet() {
            print("no internet is available.")
            CRNotifications.showNotification(type: CRNotifications.error, title: "Connectivity!", message: "No internet connection. Please try after some time", dismissDelay: 3)
            return
        }
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(searchBar.text!) {
            results, error in
            self.activityIndicator.stopAnimating()
            
            
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            
            if let results = results {
                
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                
                
                self.collectionView?.reloadData()
            }
        }
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension ViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! FlickrImgCell
        cell.thumbImageView.image = nil
        cell.thumbImageView.image = UIImage(named: "placeholderImg.png")
        
        return cell
    }
    
    
}
// MARK: - UICollectionViewDelegate
extension ViewController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let currentCell = collectionView.cellForItem(at: indexPath) as! FlickrImgCell
        let configuration = ImageViewerConfiguration { config in
            config.imageView = currentCell.thumbImageView
        }
        let imageViewerController = ImageViewerController(configuration: configuration)
        present(imageViewerController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let flickrPhoto = photoForIndexPath(indexPath)
        let cell = cell as! FlickrImgCell
        guard let imgUrlStr = flickrPhoto.thumbnail else {
            return
        }
        
        
        cell.thumbImageView.sd_setImage(with: URL(string: imgUrlStr), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        
        if indexPath.row == (searches[indexPath.section].searchResults.count)-1 && !self.waiting  {
            if !Connectivity.isConnectedToInternet() {
                print("no internet is available.")
                CRNotifications.showNotification(type: CRNotifications.error, title: "Connectivity!", message: "No internet connection. Please try after some time", dismissDelay: 3)
                return
            }
            waiting = true;
            spinner.startAnimating()
            self.loadMoreData()
        }
    }
    
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - (paddingSpace + 1)
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    
}

