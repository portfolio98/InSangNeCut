//
//  HomeButtonView.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/26.
//

import UIKit
import SnapKit
/**
 홈을 구성하는 버튼 뷰 입니다. 파라미터가 없을 경우 애니메이션이 없습니다.
 
 - Parameter
   - delay: 애니메이션 딜레이를 지정합니다.
 
 - AnimationType
    - up: 버튼 뷰가 위로 상승할 때 보여지는 애니메이션
    - down: 버튼 뷰가 아래로 내려갈 때 보여지는 애니메이션
 
 */
final class HomeButtonView: UIView {
    enum AnimationType {
        case up
        case down
    }
    
    // MARK: - initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delay: TimeInterval, emoji: String, title: String, color: UIColor) {
        self.init(frame: .zero)
        
        self.configureAnimation(delay: delay)
        self.configureUI(emoji: emoji, title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // NOTE: - 애니메이션 stop
        print("버튼뷰 deinit")
    }
    
    // MARK: - Function
    private func configureUI(emoji: String, title: String, color: UIColor) {
        self.layer.cornerRadius = 20
        self.backgroundColor = color
        self.clipsToBounds = true
        
        let label: UILabel = {
            $0.textAlignment = .center
            $0.text = emoji + "\n" + title
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .white
            $0.numberOfLines = 0
            return $0
        }(UILabel())
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Animation
    
    func configureAnimation(delay: TimeInterval) {
        let duration: TimeInterval = 2.0
        let relativeStartTime = delay / duration
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: delay,
            options: [.repeat, .allowUserInteraction]
        ) {
                self.addKeyframe(relativeStartTime: relativeStartTime, relativeDuration: 0.67, type: .up)
                self.addKeyframe(relativeStartTime: 0.67, relativeDuration: 1.0, type: .down)
            }
    }
    
    private func addKeyframe(relativeStartTime start: Double, relativeDuration duration: Double, type: AnimationType) {
        UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
            switch type {
            case .up: self.transform = CGAffineTransform(translationX: 0, y: -35)
            case .down: self.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }
}
