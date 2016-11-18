//
//  HomeTabViewModel.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import RxSwift

struct HomeTabViewModel {
    fileprivate let _funBucks: Variable<Int>
    fileprivate let disposeBag: DisposeBag
    
    init(funBucks: Int) {
        _funBucks = Variable<Int>(funBucks)
        disposeBag = DisposeBag()
    }
}

extension HomeTabViewModel {
    var funBucks: Observable<Int> {
        return _funBucks.asObservable()
    }
}
