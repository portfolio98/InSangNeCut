//
//  SettingViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: UIViewController {
    typealias SettingModel = (String, String)
    var disposeBag = DisposeBag()
    enum Reusable {
        static let setting = ReusableCell<SettingCell>()
    }
    // MARK: - Properties
    let dataSource: [SettingModel] = [
        ("홈:부스 팀", "https://quilled-gem-2be.notion.site/db0e042ee87141d197ef3aff52480ed8"),
        ("인스타그램으로 문의하기", "https://www.instagram.com/homebooth.official/"),
        ("공지사항 확인하기", "https://quilled-gem-2be.notion.site/8ac2685692104e778369099225ee8af1"),
        ("새로운 프레임 요청하기", "https://quilled-gem-2be.notion.site/8f7cbeceae3349029329fb4467f2a5b9")
    ]
    
    // MARK: - Binding
    func bind() {
        disposeBag.insert {
            Observable.of(dataSource)
                .bind(to: collectionView.rx.items(Reusable.setting)) { index, item, cell in
                    cell.configureCell(for: item)
                }
            
            collectionView.rx.modelSelected(SettingModel.self)
                .bind { item in
                    if let url = URL(string: item.1) {
                        UIApplication.shared.open(url, options: [:])
                    }
                }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appSettingColor = UIColor.init(rgb: 0xFFB34D)
        let appSettingColor = UIColor.designSystem(.mainIvory2)
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = appSettingColor
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: appSettingColor]


        self.configureUI()
        self.bind()
    }
    
    // MARK: - UIComponents
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.register(Reusable.setting)
        cv.isScrollEnabled = false
        
        return cv
    }()
}

extension SettingViewController {
    func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection in
            return self.configureSettingSection()
        }
    }
    
    private func configureSettingSection() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1
        let inset: CGFloat = 2.5
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(fraction),
                                                            heightDimension: .absolute(50)))
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .absolute(50)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}


final class SettingCell: BaseCollectionViewCell {
    
    func configureCell(for item: (String, String)) {
        let text = item.0
        settingLabel.text = text
    }
    
    // MARK: - Initialize
    override func initialize() {
        self.configureUI()
    }
    
    // MARK: - UIComponents
    var settingLabel: UILabel = {
        $0.font = .pretendardFont(size: 16, style: .semiBold)
        return $0
    }(UILabel())
    
    private func configureUI() {
        contentView.backgroundColor = .designSystem(.mainIvory)
//        UIColor(rgb: 0xFFF7F0)
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(settingLabel)
        settingLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.top.bottom.equalToSuperview()
        }
    }
}
