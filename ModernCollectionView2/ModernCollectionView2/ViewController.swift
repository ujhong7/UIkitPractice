//
//  ViewController.swift
//  ModernCollectionView2
//
//  Created by yujaehong on 7/23/24.
//

// 사용할 라이브러리
// Kingfisher - 다운로드하고 이미지를 캐시하는 역할
// Snapkit - 레이아웃 제약조건
// RxSwift - 반응형 프로그래밍 (비동기처리)
// RxAlamofire - 서버데이터 요청 쉽고 편리하게 응답값을 처리

import UIKit
import SnapKit
import RxSwift

// 섹션 - 레이아웃 관련
enum Section: Hashable {
    case double
    case banner
    case horizontal(String) // 헤더부분을 전달하기 위해 String 전달
    case vertical(String)
}

// 셀 - 아이템을 구현할 때 기준을 잡기위해
enum Item: Hashable {
    case normal(Content) // Movie
    case bigImage(Movie)
    case list(Movie)
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let buttonView = ButtonView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section,Item>?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.id)
        collectionView.register(BigImageCollectionViewCell.self, forCellWithReuseIdentifier: BigImageCollectionViewCell.id)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        return collectionView
    }()
    
    let viewModel = ViewModel()
    
    // Subject - 이벤트를 발생시키면서 Observable 형태도 되는거
    let tvTrigger = PublishSubject<Void>()
    let movieTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDataSource()
        bindViewModel()
        bindView()
        tvTrigger.onNext(())
    }
    
    private func setUI() {
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)
                
        buttonView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonView.snp.bottom)
        }
    }
    
    private func bindViewModel() {
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObservable(), movieTrigger: movieTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.tvList.bind { [weak self] tvList in
            print("TV List: \(tvList)")
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            let items = tvList.map{ Item.normal(Content(tv: $0))}
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.movieList.bind { movieResult in
            print("Movie Result: \(movieResult)")
            
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            
            let bigImageList = movieResult.nowPlaying.results.map { movie in
                return Item.bigImage(movie)
            }
            let bannerSection = Section.banner
            
            snapshot.appendSections(<#T##identifiers: [Section]##[Section]#>)
            snapshot.appendItems(<#T##identifiers: [Item]##[Item]#>)
            
          
            
            // 🚨
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {
        buttonView.tvButton.rx.tap.bind { [weak self] in
            self?.tvTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        buttonView.movieButton.rx.tap.bind { [weak self] in
            self?.movieTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .banner:
                return self?.createBannerSection()
            case .horizontal:
                return self?.createHorizontalSection()
            default:
                return self?.createDoubleSection()
            }
            
        }, configuration: config)
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(640))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .normal(let contentData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell
                cell?.configure(title: contentData.title, review: contentData.vote, desc: contentData.overview, imageURL: contentData.posterURL)
                return cell
            case .bigImage(let movieData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCollectionViewCell.id, for: indexPath) as? BigImageCollectionViewCell
                cell?.configure(title: movieData.title, overview: movieData.overview, review: movieData.vote, url: movieData.posterURL)
                return cell
//            case .list(let moiveData):
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCollectionViewCell.id, for: indexPath) as? BigImageCollectionViewCell
//                cell?.configure(title: movieData.title, overview: movieData.overview, review: movieData.vote, url: movieData.posterURL)
//                return cell
            default:
                return UICollectionViewCell()
            }
        })
    }
    
}
