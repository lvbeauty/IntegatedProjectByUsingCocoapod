//
//  SecondViewController.swift
//  Touch Novel
//
//  Created by Tong Yi on 5/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import Alamofire
import ViewAnimator

class SecondViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    var dataSource = [[DataModel.Novel]]()
    let networkManager = Service.shared
    
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: nil)
        return barButtonItem
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        return barButtonItem
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableViewSetup()
        setupData()
    }
    
    //MARK: - Set UP Data
    func setupData()
    {
        for cate in 0 ..< AppConstants.Network.urls.count
        {
            networkManager.fetchData(section: cate) { (datas) in
                guard let data = datas else {return}
                
                self.dataSource.append(data)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableViewSetup()
    {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        guard let indexPaths = tableView.indexPathsForVisibleRows else {return}
        for indexPath in indexPaths {
            let cell = tableView.cellForRow(at: indexPath) as! FeaturedTableViewCell
            cell.startEditing()
        }
    }
    
    
    @IBAction func favoriteButtonTapped(_ sender: Any)
    {
        
    }
    
}

//MARK: - Table View

extension SecondViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.width, height: 28))
        label.backgroundColor = UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)

        
        switch section {
        case 0:
            label.text = AppConstants.Network.category.Fiction.rawValue
        case 1:
            label.text = AppConstants.Network.category.Mysteries.rawValue
        case 2:
            label.text = AppConstants.Network.category.Fantasy.rawValue
        case 3:
            label.text = AppConstants.Network.category.Horror.rawValue
        case 4:
            label.text = AppConstants.Network.category.Romance.rawValue
        case 5:
            label.text = AppConstants.Network.category.Historical.rawValue
        default:
            label.text = "Others"
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: AppConstants.Cell.tableViewCellId, for: indexPath) as! FeaturedTableViewCell
        cell.contentMode = .scaleAspectFit
        
        cell.setData(listNovel: dataSource[indexPath.section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        //MARK: 3PL -> ViewAnimator -> animated
        UIView.animate(views: [cell], animations: [zoomAnimation, fromAnimation], duration: 1.5)
    }
}
