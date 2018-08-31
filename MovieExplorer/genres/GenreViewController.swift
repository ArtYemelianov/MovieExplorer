//
//  GengerViewController.swift
//  MovieExplorer
//
//  Created by artus on 30.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var genres: [Genre] = [Genre(name: "TItle", id: 25), Genre(name: "Avaranges", id: 25)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
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
