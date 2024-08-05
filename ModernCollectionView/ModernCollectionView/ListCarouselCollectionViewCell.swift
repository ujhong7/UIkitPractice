//
//  ListCarouselCollectionViewCell.swift
//  ModernCollectionView
//
//  Created by yujaehong on 7/23/24.
//

import UIKit
import SnapKit

class ListCarouselCollectionViewCell: UICollectionViewCell {
    static let id = "ListCarouselCell"
    private let mainImgage = UIImageView()
    private let titlelabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(mainImgage)
        addSubview(titlelabel)
        addSubview(subTitleLabel)
        
        mainImgage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        titlelabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(mainImgage.snp.trailing).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(8)
            make.leading.equalTo(mainImgage.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
    }
    
    func config(imageUrl: String, title: String, subTitle: String?) {
        mainImgage.kf.setImage(with: URL(string: imageUrl))
        titlelabel.text = title
        subTitleLabel.text = subTitle
    }
    
}
