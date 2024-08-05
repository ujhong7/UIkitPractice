//
//  NormalCaroselCollectionViewCell.swift
//  ModernCollectionView
//
//  Created by yujaehong on 7/23/24.
//

import UIKit
import SnapKit

class NormalCaroselCollectionViewCell: UICollectionViewCell {
    static let id = "NormalCaroselCell"
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
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        titlelabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainImgage.snp.bottom).offset(8)
        }
     
        subTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titlelabel.snp.bottom).offset(8)
        }
    }
    
    func config(imageUrl: String, title: String, subTitle: String?) {
        mainImgage.kf.setImage(with: URL(string: imageUrl))
        titlelabel.text = title
        subTitleLabel.text = subTitle
    }
    
}
