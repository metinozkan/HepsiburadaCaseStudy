//
//  MainViewController.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import UIKit
class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var itemSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        self.searchTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
    }
    

    @IBAction func segmentedClicked(_ sender: Any) {
    }
    

}


extension MainViewController :UITableViewDataSource,UITableViewDelegate {
    

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = UITableViewCell()
//            cell.textLabel?.text = "metin"
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            return cell
        }
    
    
}
