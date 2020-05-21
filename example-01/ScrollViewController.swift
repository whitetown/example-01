//
//  ScrollViewController.swift
//  example-01
//
//  Created by Sergey Chehuta on 16/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit
import SnapKit

class ScrollViewController: BaseViewController {

    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
    }
    
    private func addScrollView() {
        self.scrollView.alwaysBounceVertical = true
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        /*
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;

        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;
        */
    }

}
