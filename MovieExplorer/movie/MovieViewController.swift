//
//  MovieViewController.swift
//  MovieExplorer
//
//  Created by artus on 30.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import UIKit
import RxSwift

let showMovie = "show_movie"

class MovieViewController: UIViewController {
    
    var genre: Genre? = nil
    @IBOutlet weak var tableView: UITableView!
    private var movies: [Movie] = Array()
    private let model: MovieViewModel = MovieViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
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
        if resourse.data != nil {
            movies.removeAll()
            movies.append(contentsOf: resourse.data!)
            tableView.reloadData()
        }else if resourse.message != nil {
            print("Message error \(resourse.message!)")
        }else if resourse.status != nil {
            print("Update loading \(resourse.status!)")
        }else {
            print("Error. No one result corresponds on valid")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie_identifier", for: indexPath)
        
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColorFromRGB(rgbValue: 0xF0F0F0)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        let movie  = movies[indexPath.row]
        if let item = cell as? MovieTableViewCell{
            item.titleLabel.text = movie.title
        }
        return cell
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
