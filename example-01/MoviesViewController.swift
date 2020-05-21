//
//  MoviesViewController.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

class MoviesViewController: TableViewController {

    private var movies   = [Movie]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var filtered = [Movie]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var items: [Movie] {
        return self.inSearch ? self.filtered : self.movies
    }
    
    private let api = API()
    
    deinit {
        unsubscribeFromKeyboardEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearch()
        configureNavbar()
        configureTableView()
        loadData()
        subscribeToKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func performSearch(_ text: String) {
        self.filtered = self.movies.filter({ (movie) -> Bool in
            movie.title.uppercased().contains(text.uppercased())
        })
    }
    
    override func resetSearch() {
        self.filtered = self.movies
    }
    
    override func onKeyboardChange(_ height: CGFloat) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
    }
}

private extension MoviesViewController {

    func configureNavbar() {
        let logout = UIBarButtonItem(title: "Logout".localized, style: .done, target: self, action: #selector(logoutTap))
        self.navigationItem.rightBarButtonItems = [logout]
    }
    
    @objc func logoutTap() {
        let vc = LoginController()
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func configureTableView() {
        self.tableView.rowHeight = 80
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
    }
    
    func loadData() {
        self.api.getMovies { [weak self] (result) in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.movies = movies
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath)
        (cell as? MovieCell)?.movie = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
