//
//  ViewModel.swift
//  iContacts
//
//  Created by Yousef on 12/4/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import RxCocoa

class ViewModel {
    
    let isLoadingObservable = BehaviorRelay<Bool>(value: false)
    let msgsObservable = BehaviorRelay<String>(value: "")
    let apiErrorObservable = BehaviorRelay<APIErrorType?>(value: nil)
    
    
    
}
