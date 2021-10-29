//
//  MainViewController.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var itemSegment: UISegmentedControl!
    
    var searchData = [Result]()
    var skip = 1
    var selectedSegment = "movie"
    var isMoreDataLoading = false
    var searchBarText = ""
    
    let spinner = UIActivityIndicatorView(style: .large)
    let service = Service()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            if let destination = segue.destination as? DetailViewController, let index = searchTableView.indexPathForSelectedRow {
                destination.name = searchData[index.row].collectionName ?? "empty"
                destination.date = searchData[index.row].releaseDate
                destination.image = searchData[index.row].artworkUrl100
                destination.price = searchData[index.row].collectionPrice
            }
        }
    }
    
    
    func configureUI() {
        self.searchTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        
    }
    
    func data(term: String) {
        
        print(searchBarText,self.selectedSegment)
        
        if !self.isMoreDataLoading {
            self.isMoreDataLoading = true
            DispatchQueue.main.async {
                sleep(1)
                self.service.getData(term:term, skip: self.skip, entity: self.selectedSegment) { results in
                    self.spinner.stopAnimating()
                    if (results != nil){
                        self.searchData = results!
                        self.searchTableView.reloadData()
                        self.isMoreDataLoading = false
                    }
                 else {
                     self.searchData = []
                     self.searchTableView.reloadData()
                    }
                    
                }
            }
            
        }
        
    }
    
    @IBAction func segmentedClicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegment = "movie"
//                        data(term: searchBarText)
//                        searchTableView.reloadData()
        case 1:
            selectedSegment = "Music"
    //            data(term: searchBarText)
    //            searchTableView.reloadData()
        case 2:
            selectedSegment = "Apps"
//            data(term: searchBarText)
//            searchTableView.reloadData()
        case 3:
            selectedSegment = "Books"
//            data(term: searchBarText)
//            searchTableView.reloadData()
        default:
            return
        }
    }
    
}


extension MainViewController :UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //            let cell = UITableViewCell()
        //            cell.textLabel?.text = "metin"
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        let data = searchData[indexPath.row]
        cell.itemImage.sd_setImage(with: URL(string: data.artworkUrl100 ?? ""))
        cell.itemName.text = data.collectionName ?? "empty"
        cell.itemDate.text = data.releaseDate
        cell.itemPrice.text = "$ \( data.collectionPrice)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetail", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            self.spinner.startAnimating()
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            if (!isMoreDataLoading){
                self.skip += 1
                data(term: self.searchBarText)
            }
        }
        
    }
    
}

extension MainViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count >= 2 {
            self.searchBarText = searchBar.text!
            data(term: self.searchBarText)
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
//        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//            searchBar.text = ""
//            searchBar.endEditing(true)
//            self.searchData.removeAll()
//            self.searchData = []
//            self.searchTableView.reloadData()
//        }
    
    
}

