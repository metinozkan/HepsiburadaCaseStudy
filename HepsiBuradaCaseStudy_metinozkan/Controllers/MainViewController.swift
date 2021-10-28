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
    
    let service = Service()
    var searchData = [Result]()
    var skip = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        data()

        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        self.searchTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
    }
    
    func data() {
        service.getData(term: "wewill",skip: self.skip,entity: "album") { results in
            guard let data = results else {return}
            self.searchData = data
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    

    @IBAction func segmentedClicked(_ sender: Any) {
    }
    

}


extension MainViewController :UITableViewDataSource,UITableViewDelegate {
    

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.searchData.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = UITableViewCell()
//            cell.textLabel?.text = "metin"
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            let data = searchData[indexPath.row]
            cell.itemName.text = data.collectionName
            cell.itemDate.text = data.releaseDate
            cell.itemPrice.text = "$ \(data.collectionPrice)"
            return cell
        }
    
    
}
