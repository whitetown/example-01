//
//  TableViewController.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

class TableViewController: BaseViewController {

    internal let tableView = UITableView()
    internal let search = UISearchController(searchResultsController: nil)
    internal var inSearch = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView()
    }
    
    private func addTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func initSearch() {
        self.search.searchResultsUpdater = self
        self.navigationItem.searchController = self.search
        self.search.searchBar.delegate = self
        self.search.dimsBackgroundDuringPresentation = false
        if #available(iOS 13.0, *) {
            self.search.searchBar.searchTextField.backgroundColor = .white
            self.search.searchBar.searchTextField.tintColor = .black
        } else {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                textField.tintColor = .black
                textField.backgroundColor = .white
            }
        }
    }
    
    internal func performSearch(_ text: String) {
        
    }
    
    internal func resetSearch() {
        
    }
    
}

extension TableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            performSearch(text)
        } else {
            resetSearch()
        }
    }
}

extension TableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.inSearch = true
    }
     
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.inSearch = false
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
