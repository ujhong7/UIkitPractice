//
//  Item.swift
//  ModernCollectionView
//
//  Created by yujaehong on 7/23/24.
//

import Foundation

// 섹션과 아이템 정의

// 컬렉션뷰 섹션으로 들어가려면 Hashable 프로토콜 채택해야함
struct Section: Hashable {
    let id: String
}

enum Item: Hashable {
    case banner(HomeItem)
    case normalCarousel(HomeItem)
    case listCarousel(HomeItem)
}

struct HomeItem: Hashable {
    let title: String
    let subTitile: String?
    let imageUrl: String
    
    init(title: String, subTitile: String? = "", imageUrl: String) {
        self.title = title
        self.subTitile = subTitile
        self.imageUrl = imageUrl
    }
}
