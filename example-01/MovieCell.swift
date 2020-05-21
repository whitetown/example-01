//
//  MovieCell.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    public var movie: Movie? {
        didSet {
            updateContent()
        }
    }

    private let iv = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        
        self.iv.layer.cornerRadius = 8
        self.iv.layer.masksToBounds = true
        self.iv.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.iv)
        self.iv.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.iv.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
        }

        self.contentView.addSubview(self.subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.iv.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    private func updateContent() {
        self.titleLabel.text = self.movie?.title
        self.subtitleLabel.text = self.movie?.released
        
        guard
            let urlString = self.movie?.image,
            let imageUrl  = URL(string: urlString)
            else {
                self.iv.image = nil
                return
        }
        
        API.getImageFromURL(imageUrl) { [weak self] (image, url) in
            DispatchQueue.main.async {
                self?.iv.image = (url == imageUrl) ? image : nil
            }
        }
    }

}
