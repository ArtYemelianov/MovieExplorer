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
    private let model: GenreViewModel = GenreViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        var observable : Observable<Resource<[Genre]>> = model.loadData()
        var disposable = observable
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
        return genres.count
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
        
        let genre  = genres[indexPath.row]
        if let item = cell as? GenreTableViewCell {
            item.titleLabel.text = genre.name
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
}
