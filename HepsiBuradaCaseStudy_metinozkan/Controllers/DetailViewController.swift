//
//  DetailViewController.swift
//  HepsiBuradaCaseStudy_metinozkan
//
//  Created by Metin özkan on 28.10.2021.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    var image : String?
    var name : String?
    var price : Float?
    var date : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureUI(){
        detailImage.sd_setImage(with: URL(string: image ?? ""))
        detailName.text = "Collection Name : " + name!
        detailPrice.text = "Price : $ \(String(describing: price))"
        detailDate.text = "Release : " + date!
        
    }

}
