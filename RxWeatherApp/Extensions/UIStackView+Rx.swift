//
//  UIStackView+Rx.swift
//  RxWeatherApp
//
//  Created by антон кочетков on 14.03.2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIStackView {
    func items<Sequence: Swift.Sequence, Source: ObservableType>(
        _ source: Source
    ) -> (_ viewForRow: @escaping (Int, Sequence.Element, UIView?) -> UIView) -> Disposable where Source.Element == Sequence {
            return { viewForRow in
                return source.subscribe { event in
                    switch event {
                    case .next(let values):
                        let views = self.base.arrangedSubviews
                        let viewsCount = views.count
                        var valuesCount = 0
                        for (index, value) in values.enumerated() {
                            if index < viewsCount {
                                // update views that already exist
                                _ = viewForRow(index, value, views[index])
                            }
                            else {
                                // add new views if needed
                                let view = viewForRow(index, value, nil)
                                self.base.addArrangedSubview(view)
                            }
                            valuesCount = index
                        }
                        if valuesCount + 1 < viewsCount {
                            for index in valuesCount + 1 ..< viewsCount {
                                // remove extra views if necessary
                                self.base.removeArrangedSubview(views[index])
                                views[index].removeFromSuperview()
                            }
                        }
                    case .error(let error):
                        fatalError("Errors can't be allowed: \(error)")
                    case .completed:
                        break
                    }
                }
            }
        }
}
