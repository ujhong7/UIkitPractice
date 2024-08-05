//
//  ViewController.swift
//  ModernCollectionView
//
//  Created by yujaehong on 7/23/24.
//

// 1. 컬렉션뷰, Cell UI, 등록
// 2. 레이아웃 구현 3가지
// 3. dataSource -> cellProvider 해당데이터에 알맞는 셀을 리턴
// 4. snapshot -> dataSource에 넣어줌 dataSource.apply(snapshot)

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let imageUrl = "https://www.kyochonfnb.com/upload/img/202305/1fedc53c-8132-454f-98aa-9efca20ec922png"
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section,Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.id)
        collectionView.register(NormalCaroselCollectionViewCell.self, forCellWithReuseIdentifier: NormalCaroselCollectionViewCell.id)
        collectionView.register(ListCarouselCollectionViewCell.self, forCellWithReuseIdentifier: ListCarouselCollectionViewCell.id)
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        setDataSource()
        setSnapShot()
    }
    
    private func setUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - UICollectionViewDiffableDataSource
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .banner(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.id, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                cell.config(title: item.title, imageUrl: item.imageUrl)
                return cell
                
            case .normalCarousel(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCaroselCollectionViewCell.id, for: indexPath) as? NormalCaroselCollectionViewCell else { return UICollectionViewCell() }
                cell.config(imageUrl: item.imageUrl, title: item.title, subTitle: item.subTitile)
                return cell
                
            case .listCarousel(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.id, for: indexPath) as? ListCarouselCollectionViewCell else { return UICollectionViewCell() }
                cell.config(imageUrl: item.imageUrl, title: item.title, subTitle: item.subTitile)
                return cell
                
            default:
                return UICollectionViewCell()
            }
            
        })
    }
    
    // MARK: - NSDiffableDataSourceSnapshot
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        
        let bannerSection = Section(id: "Banner")
        snapshot.appendSections([bannerSection])
        let bannerItems = [
            Item.banner(HomeItem(title: "교촌", imageUrl: imageUrl)),
            Item.banner(HomeItem(title: "굽네", imageUrl: imageUrl)),
            Item.banner(HomeItem(title: "BBQ", imageUrl: imageUrl))
        ]
        snapshot.appendItems(bannerItems, toSection: bannerSection)
        
        
        let normalSection = Section(id: "NormalCarousel")
        snapshot.appendSections([normalSection])
        let normalItems = [
            Item.normalCarousel(HomeItem(title: "교촌", subTitile: "간장 치킨", imageUrl: imageUrl)),
            Item.normalCarousel(HomeItem(title: "굽네", subTitile: "오븐 치킨", imageUrl: imageUrl)),
            Item.normalCarousel(HomeItem(title: "BBQ", subTitile: "후라이드 치킨", imageUrl: imageUrl)),
            Item.normalCarousel(HomeItem(title: "푸라닭", subTitile: "양념 치킨", imageUrl: imageUrl)),
            Item.normalCarousel(HomeItem(title: "BHC", subTitile: "갈릭 치킨", imageUrl: imageUrl)),
            Item.normalCarousel(HomeItem(title: "자담", subTitile: "떡볶이 치킨", imageUrl: imageUrl)),
        ]
        snapshot.appendItems(normalItems, toSection: normalSection)
        
        let listSection = Section(id: "ListCarousel")
        snapshot.appendSections([listSection])
        let listItems = [
            Item.listCarousel(HomeItem(title: "교촌2", subTitile: "간장 치킨", imageUrl: imageUrl)),
            Item.listCarousel(HomeItem(title: "굽네2", subTitile: "오븐 치킨", imageUrl: imageUrl)),
            Item.listCarousel(HomeItem(title: "BBQ2", subTitile: "후라이드 치킨", imageUrl: imageUrl)),
            Item.listCarousel(HomeItem(title: "푸라닭2", subTitile: "양념 치킨", imageUrl: imageUrl)),
            Item.listCarousel(HomeItem(title: "BHC2", subTitile: "갈릭 치킨", imageUrl: imageUrl)),
            Item.listCarousel(HomeItem(title: "자담2", subTitile: "떡볶이 치킨", imageUrl: imageUrl)),
        ]
        snapshot.appendItems(listItems, toSection: listSection)
        
        dataSource?.apply(snapshot)
    }
    
    // MARK: - UICollectionViewCompositionalLayout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            
            switch sectionIndex {
            case 0:
                return self?.createBannerSection()
            case 1:
                return self?.createNormalCaroselSection()
            case 2:
                return self?.createListCarouselSection()
            default:
                return self?.createBannerSection()
            }
            return self?.createBannerSection()
        }, configuration: config)
    }
    
    // MARK: - NSCollectionLayoutSection
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createNormalCaroselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
    
    private func createListCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}
