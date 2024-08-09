//
//  ViewModel.swift
//  ModernCollectionView2
//
//  Created by yujaehong on 7/25/24.
//

import Foundation
import RxSwift

class ViewModel {
    
    let disposeBag = DisposeBag()
    
    private let tvNetwork: TVNetwork
    private let moiveNetwork: MovieNetwork
    public var currentContentType: ContentType = .tv
    private var currentTVList: [TV] = []
    
    init() {
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
        moiveNetwork = provider.makeMoviveNetwork()
    }
    
    struct Input {
        let keyword: Observable<String>
        let tvTrigger: Observable<Int>
        let movieTrigger: Observable<Void>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
        let movieList: Observable<Result<MovieResult,Error>>
    }
    
    func transform(input: Input) -> Output {
        
        Observable.combineLatest(input.tvTrigger, input.keyword)
            .flatMap { [unowned self ]page, keyword in
                <#code#>
            }
        
        // trigger -> 네트워크 -> Observable<T> -> VC 전달 -> VC에서 구독
        
        // tvTrigger -> Observable<Void> -> Observable<[TV]>
//        let tvList = input.tvTrigger.flatMapLatest { [unowned self] page -> Observable<[TV]> in
//            if page == 1 { currentTVList = [] }
//            self.currentContentType = .tv
//            return self.tvNetwork.getTopRatedList(page: page).map { $0.results }.map { tvlist in
//                // 현재 리스트 + 새로운 리스트
//                self.currentTVList += tvlist
//                return self.currentTVList
//            }
//        }
        
        let movieResult = input.movieTrigger.flatMap { [unowned self] _ -> Observable<Result<MovieResult,Error>> in
            // combineLatest
            // Observable 1, 2, 3 합쳐서 하나의 Observable로 바꾸고싶다면?
            // combineLatest가 뭐임?
            return Observable.combineLatest(self.moiveNetwork.getUpComingList(), self.moiveNetwork.getPopularList(), self.moiveNetwork.getNowPlayingList()) {
                upcoming, popular, nowPlaying -> Result<MovieResult,Error> in
                self.currentContentType = .movie
                return .success(MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowPlaying))
            }.catchError { error in
                print(error)
                return Observable.just(.failure(error))
            }
        }
        
        return Output(tvList: tvList, movieList: movieResult)
    }
    
}
