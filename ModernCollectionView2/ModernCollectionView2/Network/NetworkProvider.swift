//
//  NetworkProvider.swift
//  ModernCollectionView2
//
//  Created by yujaehong on 7/24/24.
//

import Foundation

// 어떤 네트워크든지 생성할 수 있는 클래스

final class NetworkProvider {
    private let endpoint: String
   
    init() {
        self.endpoint = "https://api.themoviedb.org/3"
    }
    
    func makeTVNetwork() -> TVNetwork {
        let network = Network<TVListModel>(endpoint)
        return TVNetwork(network: network)
    }
    
    func makeMoviveNetwork() -> MovieNetwork {
        let network = Network<MovieListModel>(endpoint)
        return MovieNetwork(network: network)
    }
    
    func makeReviewNetwork() -> ReviewNetwork {
        let network = Network<ReviewListModel>(endpoint)
        return ReviewNetwork(network: network)
    }
 
}
