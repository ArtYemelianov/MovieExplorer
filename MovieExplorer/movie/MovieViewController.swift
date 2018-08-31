//
//  MovieViewController.swift
//  MovieExplorer
//
//  Created by artus on 30.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import UIKit

let showMovie = "show_movie"

class MovieViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var genre: Genre? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = genre?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
