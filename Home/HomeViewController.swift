//
//  HomeViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture
import WidgetKit

final class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    // MARK: - Binding
    func bind() {
        disposeBag.insert {
            설정BarButtonItem.rx.tap
                .withUnretained(self)
                .bind { this, _ in
                    this.showSettingViewController()
                }
            
            촬영하러가기버튼뷰.rx.tapGesture()
                .when(.recognized)
                .withUnretained(self)
                .bind { this, _ in
                    this.showChooseFrameViewController(neCutMakeType: .basic_frame_4x1, nextViewType: .카메라)
                }
            
            포토컷만들기버튼뷰.rx.tapGesture()
                .when(.recognized)
                .withUnretained(self)
                .bind { this, _ in
                    this.showChooseFrameViewController(neCutMakeType: .basic_frame_4x1, nextViewType: .포토컷)
                }
            
            보관함가기버튼뷰.rx.tapGesture()
                .when(.recognized)
                .withUnretained(self)
                .bind { this, _ in
                    this.showLockerViewContoller()
                }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        촬영하러가기버튼뷰.configureAnimation(delay: 0.3)
        포토컷만들기버튼뷰.configureAnimation(delay: 0.0)
        보관함가기버튼뷰.configureAnimation(delay: 0.2)
    }
    
    // MARK: - UIComponents
    lazy var 설정BarButtonItem = TitleBarButtonItem(title: "설정")
    
    lazy var 설명Label: UILabel = {
        let firstLine = "가장 기록하고 싶은 순간을 떠올리며"
        let secondLine = "멋진 사진을 만들어 보세요"
        let text = """
        \(firstLine)
        \(secondLine)
        """
        
        let firstFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let secondFont = UIFont.systemFont(ofSize: 27, weight: .heavy)
        
        let attributedStr = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedStr.length))
        
        attributedStr.addAttribute(.font, value: firstFont, range: (text as NSString).range(of: firstLine))
        attributedStr.addAttribute(.foregroundColor,
                                   value: UIColor.darkGray,
                                   range: (text as NSString).range(of: firstLine))
        
        attributedStr.addAttribute(.font, value: secondFont, range: (text as NSString).range(of: secondLine))
        attributedStr.addAttribute(.foregroundColor,
                                   value: UIColor.designSystem(.mainPoint),
                                   range: (text as NSString).range(of: secondLine))
        
        $0.attributedText = attributedStr
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    lazy var 촬영하러가기버튼뷰 = HomeButtonView(delay: 0.3, emoji: "📸", title: "촬영하기", color: .designSystem(.mainPurple))
    lazy var 포토컷만들기버튼뷰 = HomeButtonView(delay: 0.0, emoji: "🖼️", title: "사진첩에서 가져오기", color: .designSystem(.mainBlue))
    lazy var 보관함가기버튼뷰 = HomeButtonView(delay: 0.2, emoji: "📦", title: "보관함 가기", color: .designSystem(.mainYellow))
    
    let a = PlusCircleBarButtonItem(tintColor: .green)
}

extension HomeViewController {
    func configureUI() {
        enum Metric: CGFloat {
            case margin = 21.0
            case spacing = 8.0
        }
        
        let margin = Metric.margin.rawValue * 2
        let spacing = Metric.spacing.rawValue * 2
        let componentWidth = (view.bounds.width - margin - spacing) / 3
        let componentHeight = componentWidth * 1.2
        
        navigationItem.rightBarButtonItem = 설정BarButtonItem
        
        view.addSubview(설명Label)
        설명Label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(-100)
        }
        
        view.addSubview(포토컷만들기버튼뷰)
        포토컷만들기버튼뷰.snp.makeConstraints {
            $0.width.equalTo(componentWidth)
            $0.height.equalTo(componentHeight)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
        }
        
        view.addSubview(촬영하러가기버튼뷰)
        촬영하러가기버튼뷰.snp.makeConstraints {
            $0.width.equalTo(componentWidth)
            $0.height.equalTo(componentHeight)
            $0.centerY.equalTo(포토컷만들기버튼뷰)
            $0.trailing.equalTo(포토컷만들기버튼뷰.snp.leading).offset(-spacing/2)
        }

        view.addSubview(보관함가기버튼뷰)
        보관함가기버튼뷰.snp.makeConstraints {
            $0.width.equalTo(componentWidth)
            $0.height.equalTo(componentHeight)
            $0.centerY.equalTo(포토컷만들기버튼뷰)
            $0.leading.equalTo(포토컷만들기버튼뷰.snp.trailing).offset(spacing/2)
        }
    }
}
