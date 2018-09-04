//
//  GengerViewController.swift
//  MovieExplorer
//
//  Created by artus on 30.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import UIKit
import RxSwift

class GenreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var genres: [Genre] = Array()
    private var filtered: [Genre] = Array()
    private let model: GenreViewModel = GenreViewModel()
    private let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Genres"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        let observable : Observable<Resource<[Genre]>> = model.loadData()
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
    
    
    private func update(resourse : Resource<[Genre]>){
        if resourse.data != nil {
            genres.removeAll()
            genres.append(contentsOf: resourse.data!)
            filtered = filterData(data: genres, pattern: searchController.searchBar.text ?? "")
            tableView.reloadData()
        }else if resourse.message != nil {
            print("Message error \(resourse.message!)")
        }else if resourse.status != nil {
            print("Update loading \(resourse.status!)")
        }else {
            print("Error. No one result corresponds on valid")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case showMovie:
            guard let cell = sender as? GenreTableViewCell,
                let indexPath = tableView.indexPath(for: cell)
                else {
                    return
            }
            let controller  = segue.destination as! MovieViewController
            controller.genre = genres[indexPath.row]
        default: break
            //do nothing
        }
    }
}

extension GenreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genre_identifier", for: indexPath)
        
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColorFromRGB(rgbValue: 0xF0F0F0)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        let genre  = filtered[indexPath.row]
        if let item = cell as? GenreTableViewCell {
            item.titleLabel.text = genre.name
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension GenreViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = filterData(data: genres, pattern: searchText)
        tableView.reloadData()
    }
}

extension GenreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filtered = filterData(data: genres, pattern: searchController.searchBar.text ?? "")
    }
}

extension GenreViewController {
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /**
     Filters data by specific pattern
     */
    fileprivate func filterData(data: [Genre], pattern: String) -> [Genre] {
        return pattern.isEmpty ? data : data.filter({ item -> Bool in
            return item.name.range(of: pattern, options: .caseInsensitive, range: nil, locale: nil) != nil
            
        })
    }
}
