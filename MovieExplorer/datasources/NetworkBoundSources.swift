//
//  NetworkBoundSources.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

/**
 Class binds network and storage requests
 */
class NetworkBoundSources<Element> {
    public typealias E = Element
    private let disposeBag = DisposeBag()
    private let url: String

    init(url: String) {
        self.url = url
    }
    
    private lazy var result: Observable<Resource<E>> = Observable<Resource<E>>.create({ observer -> Disposable in
        let value: AnyObserver<Resource<E>> = observer
        self.start(value)
        return Disposables.create {
            print("NetworkBoundSources disposed")
        }
    })
    
    
    private func start(_ observer : AnyObserver<Resource<E>>){
        observer.onNext(Resource.loading)
        let dataSource = loadFromDatabase()
        dataSource.subscribe(onNext: { [unowned self] item -> Void in
            if self.shouldLoadFromNetwork(data: item){
                self.fetchNetworkData(observer)
            }else{
                observer.onNext(Resource<E>.success(data: item))
                observer.onCompleted()
            }
        }, onError: { error  in
            print("NetworkBoundSources::start, onError happens")
            observer.onError(error)
        }, onCompleted: {
            print("NetworkBoundSources::start, onCompleted")
            observer.onCompleted()
        }, onDisposed: {
            print("NetworkBoundSources::start, onDisposed")
        })
    }
    
    /**
     Fetches data from network
     - Parameter observer: Observer
     */
    private func fetchNetworkData(_ observer: AnyObserver<Resource<E>>){
        let parsing: ((Data) throws -> E) = { data in
            return try self.parseData(data)
        }
        let result = NetworkService.request(url: url, parse: parsing)
        guard result.data != nil else {
            observer.onNext(Resource<E>.error(msg: "Data is nil"))
            observer.onCompleted()
            return
        }
        // put operation into io thread
        saveNetworkCallResult(data: result.data!)
        observer.onNext(result)
        observer.onCompleted()
    }
    
    var asObservable: Observable<Resource<E>> {
        get {
            return result
        }
    }
    
    func parseData(_ data: Data) throws -> E{
        fatalError("Need implement parseData")
    }
    
    func saveNetworkCallResult(data: E?){
        fatalError("Need implement saveNetworkCallResult")
    }
    
    func shouldLoadFromNetwork(data: E?) -> Bool {
        fatalError("Need implement shouldLoadFromNetwork")
    }

    func loadFromDatabase() -> Observable<E> {
        fatalError("Need implement loadFromDatabase")
    }
}
