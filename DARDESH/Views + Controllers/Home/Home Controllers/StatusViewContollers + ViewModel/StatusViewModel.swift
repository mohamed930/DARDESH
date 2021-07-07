//
//  StatusViewModel.swift
//  DARDESH
//
//  Created by Mohamed Ali on 07/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

class StatusViewModel {
    
    var checkmarksStatus = BehaviorRelay<String>(value: "")
    
    private var StatusModelSubject = PublishSubject<[StatusModel]>()
    var StatusModelObservable: Observable<[StatusModel]> {
        return StatusModelSubject
    }
    
    func GetData() {
        
        let data = ["Avaliable","Busy","At School","At The Movies","At Work","Battary About to die","Can't Talk","In a Meating","At the gym","Sleeping","Ungent calls Only"]
        
        var statusModels = Array<StatusModel>()
        
        for i in data {
            if i == checkmarksStatus.value {
                let ob = StatusModel(statusName: i, checkMark: true)
                statusModels.append(ob)
            }
            else {
                let ob = StatusModel(statusName: i, checkMark: false)
                statusModels.append(ob)
            }
        }
        
        StatusModelSubject.onNext(statusModels)
        
    }
    
}
