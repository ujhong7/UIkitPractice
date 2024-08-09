//
//  TVNetwork.swift
//  ModernCollectionView2
//
//  Created by yujaehong on 7/24/24.
//

import Foundation
import RxSwift

final class TVNetwork {
    private let network: Network<TVListModel>
    
    init(network: Network<TVListModel>) {
        self.network = network
    }
    
    func getTopRatedList(page: Int) -> Observable<TVListModel> {
        return network.getItemList(path: "/tv/top_rated", page: page)
    }
    
    func getQueriedList(page: Int, query: String) -> Observable<TVListModel> {
        return network.getItemList(path: "/search/tv", page: page, query: query)
    }
    
}
