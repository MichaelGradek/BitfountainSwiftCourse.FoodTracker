//
//  ViewController.swift
//  FoodTracker
//
//  Created by Michael on 20/12/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // Variables
    var searchController: UISearchController!
    var suggestedSearchFoods: [String] = []
    var filteredSuggestSearchFoods: [String] = []
    var scopeButtonTitles = ["Recommended", "Search Results", "Saved"]
    
    
    // ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.frame = CGRectMake(
            self.searchController.searchBar.frame.origin.x,
            self.searchController.searchBar.frame.origin.y,
            self.searchController.searchBar.frame.size.width,
            44.0
        )
        
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.delegate = self
        self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        self.definesPresentationContext = true
        
        self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicen breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // Mark - UITabeViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        var foodName: String
        
        if self.searchController.active {
            foodName = filteredSuggestSearchFoods[indexPath.row]
        } else {
            foodName = suggestedSearchFoods[indexPath.row]
        }
        
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.active {
            return self.filteredSuggestSearchFoods.count
        } else {
            return self.suggestedSearchFoods.count
        }
        
    }
    
    
    // Mark - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        self.tableView.reloadData()
        
    }
    
    func filterContentForSearch(searchText: String, scope: Int) {

        if searchText == "" {
            self.filteredSuggestSearchFoods = self.suggestedSearchFoods
        } else {
            self.filteredSuggestSearchFoods = self.suggestedSearchFoods.filter({ (food: String) -> Bool in
                var foodMatch = food.rangeOfString(searchText)
                return foodMatch != nil
            })
        }
        
    }
    
    // Mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        println("clicked")
        makeRequest(searchBar.text)
        
    }
    
    
    // Mark - API Requests
    func makeRequest(searchString: String) {
        
        let URL = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=15f1098a&appKey=408d620fe4c82086f0436a9659be5e22")
        let task = NSURLSession.sharedSession().dataTaskWithURL(URL!, completionHandler: { (data, response, error) -> Void in
            println(data)
            println(response)
        })
        task.resume()
        
    }
    
    
}

