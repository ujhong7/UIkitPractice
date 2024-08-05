//
//  Network.swift
//  ModernCollectionView2
//
//  Created by yujaehong on 7/24/24.
//

import Foundation
import RxSwift
import RxAlamofire

class Network<T:Decodable> {
    
    private let endpoint: String
    private let queue: ConcurrentDispatchQueueScheduler
    
    init(_ endpoint: String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func getItemList(path: String) -> Observable<T>  {
        let fullPath = "\(endpoint)\(path)?api_key=\(APIKEY)&language=ko"
        return RxAlamofire.data(.get, fullPath)
            .observeOn(queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
    
}
