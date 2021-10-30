//
//  MainViewController.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import UIKit
import SDWebImage
import Foundation
import HLBarIndicatorView

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var itemSegment: UISegmentedControl!
    
    var searchData = [Result]()
    var skip = 1
    var selectedSegment = "movie"
    var isMoreDataLoading = false
    var searchBarText = ""
    var loading = HLBarIndicatorView()
    var searchWorkItem: DispatchWorkItem?
    
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
                
                let splitDateString = searchData[index.row].releaseDate?.components(separatedBy: "T")
                let date: String = splitDateString![0]
                destination.date = date
                destination.image = searchData[index.row].artworkUrl100
                destination.price = searchData[index.row].collectionPrice
                
            }
        }
    }
    
    
    func configureUI() {
        self.searchTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        
        //        self.searchTableView.estimatedRowHeight = 44
        //        self.searchBar.showsCancelButton = true
        
    }
    
    func data(term: String) {
        
        print(term,self.selectedSegment, self.isMoreDataLoading)
        if !self.spinner.isAnimating
        { loadingSpinner()}
        if !self.isMoreDataLoading {
            self.isMoreDataLoading = true
            DispatchQueue.main.async {
                sleep(2)
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
                        self.isMoreDataLoading = false
                    }
                    
                }
            }
            
        }
        
    }
    
    @IBAction func segmentedClicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegment = "movie"
            data(term: searchBarText)
            searchTableView.reloadData()
        case 1:
            selectedSegment = "song"
            data(term: searchBarText)
            searchTableView.reloadData()
        case 2:
            selectedSegment = "podcast"
            data(term: searchBarText)
            searchTableView.reloadData()
        case 3:
            selectedSegment = "ebook"
            data(term: searchBarText)
            searchTableView.reloadData()
        default:
            return
        }
    }
    
    func loadingSpinner(){
        let indicatorView = HLBarIndicatorView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 80))
        indicatorView.indicatorType = .barScaleFromRight
        indicatorView.center = self.view.center
        indicatorView.barColor = .systemYellow
        self.loading.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loading.pauseAnimating()
            indicatorView.isHidden = true
        }
        self.view.addSubview(indicatorView)
    }
    
    
}




extension MainViewController :UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchData.count == 0 {
            self.searchTableView.setEmptyMessage("Empty Page !")
        } else {
            self.searchTableView.restore()
        }
        
        return self.searchData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //            let cell = UITableViewCell()
        //            cell.textLabel?.text = "metin"
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        let data = searchData[indexPath.row]
        cell.itemImage.sd_setImage(with: URL(string: data.artworkUrl100 ?? ""))
        cell.itemName.text = data.collectionName ?? "empty"
        
        let splitDateString = data.releaseDate?.components(separatedBy: "T")
        let date: String = splitDateString![0]
        cell.itemDate.text = date
        cell.itemPrice.text = "$ \( data.collectionPrice ?? 0.0 )"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if searchBar.text!.count >= 2 {
//            self.searchBarText = searchBar.text!
//            data(term: self.searchBarText)
//            DispatchQueue.main.async {
//                self.searchTableView.reloadData()
//            }
//        }
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("clickcancel")
            searchBar.endEditing(true)
            self.searchBarText = ""
            self.searchData = []
            self.searchTableView.reloadData()
        }
        
        guard let text = searchBar.text, text.count >= 2 else { return }
        searchWorkItem?.cancel()
        let newTask = DispatchWorkItem { [weak self] in
            self!.data(term: text)
        }
        self.searchWorkItem = newTask
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newTask)
    }
    
    
    
}



