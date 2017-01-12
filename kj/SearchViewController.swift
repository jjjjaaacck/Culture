//
//  SearchViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/13.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet var tableview: UITableView!
    
    
    var searchController: UISearchController!
    var category = Category()
    var searchResult = [(title: String, id: String)]() {
        didSet {
            self.tableview.reloadData()
        }
    }
    var searchText = ""
    var searchClassify = [
        0: Array(1...19),
        1: [1, 5, 17],
        2: [2, 3, 8],
        3: [6, 7, 19],
        4: [13, 14],
        5: [4, 11],
        6: [15]
    ]
    
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
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableview.tableHeaderView = searchController.searchBar
        tableview.sectionIndexMinimumDisplayRowCount = 1
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()    }
    
    func searchForData(_ searchBarText: String, categoryIndex: Int) {
        let filter = NSPredicate(format: "category IN %@ AND title CONTAINS '\(searchBarText)'", searchClassify[categoryIndex]!)
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueOnSuccessWith{
            task in
            let data = task as! [MainData]
            self.searchResult = data.map{ ($0.title, $0.id) }
            }.continueWith{ task in
                if task.faulted {
                    self.searchResult.append(("查無資料", ""))
                }
        }
    }
    
    //MARK: tableView Delegate
    
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
            cell.searchLabel.text = searchResult[indexPath.row].title
            if searchResult[indexPath.row].title != "查無資料" {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchResult[indexPath.row].title != "查無資料" {
            performSegue(withIdentifier: "showSearchDetail", sender: searchResult[indexPath.row].id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionController = segue.destination as! TransitionViewController
        transitionController.mainDataId = sender as! String
    }
    
    //MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        searchResult.removeAll(keepingCapacity: false)
        if searchController.searchBar.text != "" {
            searchForData(searchController.searchBar.text!, categoryIndex: searchController.searchBar.selectedScopeButtonIndex)
        }
    }
    
    //MARK: searchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchResult.removeAll(keepingCapacity: false)
        if searchBar.text != "" {
            searchForData(searchController.searchBar.text!, categoryIndex: searchController.searchBar.selectedScopeButtonIndex)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}
