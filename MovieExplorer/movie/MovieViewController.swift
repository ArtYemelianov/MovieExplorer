//
//  MovieViewController.swift
//  MovieExplorer
//
//  Created by artus on 30.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

let showMovie = "show_movie"

class MovieViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var genre: Genre? = nil
    private var movies: [Movie] = Array()
    private let model: MovieViewModel = MovieViewModel()
    private let disposeBag  = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let observable : Observable<Resource<[Movie]>> = model.loadData(genre!.id)
        let disposable = observable
            .subscribeOn(AppExecutors.background)
            .observeOn(AppExecutors.main)
            .subscribe(onNext: {[weak self] item in
                self?.update(resourse: item)
                }, onError: { error in
                    
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
        disposeBag.insert(disposable)
    }
    
    private func update(resourse : Resource<[Movie]>){
        if resourse.data != nil && resourse.status == true {
            movies.removeAll()
            movies.append(contentsOf: resourse.data!)
            collectionView!.reloadData()
        }else if  resourse.data != nil {
            movies.removeAll()
            movies.append(contentsOf: resourse.data!)
            collectionView.reloadData()
        }else if resourse.message != nil {
            print("Message error \(resourse.message!)")
        }else if resourse.status != nil {
            print("Update loading \(resourse.status!)")
        }else {
            print("Error. No one result corresponds on valid")
        }
    }
    
    
}



extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movie_identifier", for: indexPath)
        let movie = movies[indexPath.row]
        if let item = cell as? MovieViewCell{
            item.titleView.text = movie.title
            if movie.backdrop_path != nil {
                let url = URL(string: Repository.compose_image_url(for: movie.backdrop_path!))
                item.imageView.kf.setImage(with: url,
                                           placeholder: nil,
                                           options: [.transition(ImageTransition.fade(1))],
                                           progressBlock: { receivedSize, totalSize in
                                            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
                },
                                           completionHandler: { image, error, cacheType, imageURL in
                                            print("\(indexPath.row + 1): Finished")
                })
            }
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! MovieViewCell).imageView.kf.cancelDownloadTask()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MovieViewController {
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension MovieViewController {
    
}
