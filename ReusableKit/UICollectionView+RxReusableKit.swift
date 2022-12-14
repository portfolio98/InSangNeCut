//
//  UICollectionView+RxReusableKit.swift
//  BlackCatSDK
//
//  Created by Hamlit Jason on 2022/10/09.
//
//
import RxCocoa
import RxSwift

#if os(iOS)
import UIKit

extension Reactive where Base: UICollectionView {
  public func items<S: Sequence, Cell: UICollectionViewCell, O: ObservableType>(
    _ reusableCell: ReusableCell<Cell>
  ) -> (_ source: O)
    -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
    -> Disposable
    where O.Element == S {
    return { source in
      return { configureCell in
        return self.items(cellIdentifier: reusableCell.identifier, cellType: Cell.self)(source)(configureCell)
      }
    }
  }
}
#endif
