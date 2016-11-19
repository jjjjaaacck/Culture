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
        dismissController()
    }
    var searchController: UISearchController!
    var category = Category()
    var searchResult = [(title: String, id: String)]()
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
        searchController.dimsBackgroundDuringPresentation = false
        tableview.tableHeaderView = searchController.searchBar
        tableview.sectionIndexMinimumDisplayRowCount = 1
        tableview.reloadData()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(SearchViewController.dismissController))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func dismissController() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transition,forKey:nil)
        
        self.dismiss(animated: false, completion: nil)
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
    
    func tableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taleView.deselectRow(at: indexPath, animated: true)
        if searchResult[indexPath.row].title != "查無資料" {
            performSegue(withIdentifier: "showSearchDetail", sender: searchResult[indexPath.row].id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchController.isActive = false
        backButton.isEnabled = true
        let transitionController = segue.destination as! TransitionViewController
        transitionController.mainDataId = sender as! String
    }
    
    //MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        searchResult.removeAll(keepingCapacity: false)
        if searchController.searchBar.text != "" {
            searchForData(searchController.searchBar.text!, categoryIndex: searchController.searchBar.selectedScopeButtonIndex)
        }
        searchText = searchController.searchBar.text!
        
        tableview.reloadData()
    }
    
    //MARK: searchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchResult.removeAll(keepingCapacity: false)
        if searchBar.text != "" {
            searchForData(searchController.searchBar.text!, categoryIndex: searchController.searchBar.selectedScopeButtonIndex)
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
