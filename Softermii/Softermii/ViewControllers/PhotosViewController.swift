//
//  PhotosViewController.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/17/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import Kingfisher

class PhotosViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var photosCollection: UICollectionView!
    var photos:[FlickrPhotoResponse] = []
    var total = 0
    var lastPage = 0
    var searchRequest:URLSessionTask?
    var layout:PinterestLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = photosCollection!.collectionViewLayout as? PinterestLayout;
        layout!.delegate = self;
        navigationItem.titleView = searchBar
        search(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(_ from:Int) {
        if from == lastPage && from != 0 {
            return
        }
        lastPage = from
        searchRequest?.cancel()
        searchRequest = API.searchPhoto(searchBar.text!, page: from, sender: self, success: { [weak self](photos, total) in
            self?.total = total
            if from == 0 {
                self?.photos = photos
            } else {
                self?.photos.append(contentsOf: photos)
            }
            self?.layout?.cachedAttributes = []
            self?.photosCollection.reloadData()
        }, failure: { 
            
        })
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(0)
    }
}

extension PhotosViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrPhotoCell", for: indexPath) as! FlickrPhotoCell
        let photo = photos[indexPath.row]
        if photo.image == nil {
            self.updateCell(cell, image: #imageLiteral(resourceName: "avatarPlaceholder"), text:photo.title!)
            cell.imageView.kf.setImage(with: URL(string: photo.imagePath ?? ""), placeholder: #imageLiteral(resourceName: "avatarPlaceholder"), options: nil, progressBlock: nil) {[weak self](image, _, _, _) in
                photo.image = image
                self?.updateCell(cell, image:image!, text:photo.title!)
            }
        } else {
            self.updateCell(cell, image: photo.image!, text:photo.title!)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func updateCell(_ cell:FlickrPhotoCell, image:UIImage, text:String) {
        photosCollection.performBatchUpdates({
            cell.setModel(image, text: text)
            if let indexPath = self.photosCollection.indexPath(for: cell) {
                self.photosCollection.reloadItems(at: [indexPath])
                self.layout?.cachedAttributes = []
                self.layout?.prepare()
            }
        }, completion: { (finished) in
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 5 {
            search(lastPage + 1)
        }
    }
}

extension PhotosViewController: PinterestLayoutDelegate {
    func heightForImageAtIndexPath(_ collectionView : UICollectionView, indexPath : IndexPath, width : CGFloat) -> CGFloat {
        let photo = photos[indexPath.row]
        if let _ = photo.image {
            return FlickrPhotoCell.imageHeightWithImage(photo.image!, cellWidth:width)
        } else {
            return 0.0
        }
    }
    
    func heightForBodyAtIndexPath(_ collectionView : UICollectionView, indexPath : IndexPath, width : CGFloat) -> CGFloat {
        let photo = photos[indexPath.row]
        return FlickrPhotoCell.bodyHeightWithText(photo.title!, cellWidth:width)
    }
}
