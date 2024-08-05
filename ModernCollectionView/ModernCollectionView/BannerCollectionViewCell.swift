//
//  BannerCollectionViewCell.swift
//  ModernCollectionView
//
//  Created by yujaehong on 7/23/24.
//

import UIKit
import SnapKit
import Kingfisher

class BannerCollectionViewCell: UICollectionViewCell {
    
    static let id = "BannerCell"
    let titleLabel = UILabel()
    let backgroundImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(backgroundImage)
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func config(title: String, imageUrl: String) {
        titleLabel.text = title
        let url = URL(string: imageUrl)
        backgroundImage.kf.setImage(with: url)
    }
    
}
