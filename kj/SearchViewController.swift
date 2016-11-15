//
//  SearchViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/13.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var tableview: UITableView!
    
    @IBAction func backButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    var searchController: UISearchController!
    var category = Category()
    var searchResult = [String]()
    var coreDataController = CoreDataController()
    var searchText = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        tableview.dataSource = self
        tableview.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.scopeButtonTitles = category.category
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        tableview.tableHeaderView = searchController.searchBar
        tableview.sectionIndexMinimumDisplayRowCount = 1
        tableview.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive)
        {
            return searchResult.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTblViewCell
        if searchController.isActive {
            cell.searchLabel.text = searchResult[(indexPath as NSIndexPath).row]
            if searchResult[(indexPath as NSIndexPath).row] != "查無資料" {
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            return cell
        }
        else {
            cell.searchLabel.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResult[(indexPath as NSIndexPath).row] != "查無資料" {
            performSegue(withIdentifier: "showSearchDetail", sender: searchResult[(indexPath as NSIndexPath).row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchController.isActive = false
        backButton.isEnabled = true
        let transitionController = segue.destination as! TransitionViewController
        transitionController.searchTitle = sender as! String
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchResult.removeAll(keepingCapacity: false)
        if searchController.searchBar.text != "" {
            let categoryIndex = searchController.searchBar.selectedScopeButtonIndex
            
//            searchResult = coreDataController.getTitleByClass(categoryIndex, condition: searchController.searchBar.text!)
            
            if searchResult.isEmpty {
                searchResult.append("查無資料")
            }
        }
        searchText = searchController.searchBar.text!
        
        tableview.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchResult.removeAll(keepingCapacity: false)
        if searchBar.text != "" {
//            searchResult = coreDataController.getTitleByClass(selectedScope, condition: searchBar.text!)
            
            if searchResult.isEmpty {
                searchResult.append("查無資料")
            }
        }
        
        tableview.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        backButton.isEnabled = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        backButton.isEnabled = false
    }
}
