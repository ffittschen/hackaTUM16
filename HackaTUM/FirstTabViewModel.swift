//
//  FirstTabViewModel.swift
//  HackaTUM
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import RxSwift

struct FirstTabViewModel {
    fileprivate let disposeBag: DisposeBag
    
    fileprivate let string: Variable<String>
    
    init(string: String) {
        self.string = Variable<String>(string)
        
        disposeBag = DisposeBag()
    }
}

extension FirstTabViewModel {
    var stringValue: Observable<String> {
        return string.asObservable()
    }
}
