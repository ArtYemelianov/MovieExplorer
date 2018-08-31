//
//  NetworkBoundSources.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import RxSwift

class NetworkBoundSources<Element> {
    public typealias E = Element
    
    private let result = Observable<Resource>.create({
        
    }).
    
//    init {
//        result.value = Resource.loading(null)
//        val dbSource = loadFromDatabase()
//        result.addSource(dbSource) { data ->
//            result.removeSource(dbSource)
//            if (shouldLoadFromNetwork(data)) {
//                fetchFromNetwork(dbSource)
//            } else {
//                result.addSource(dbSource) { newData -> result.setValue(Resource.success(newData)) }
//            }
//        }
//    }
//
//    private fun fetchFromNetwork(dbSource: LiveData<T>) {
//
//    appExecutors.networkIO().execute {
//
//    try {
//    val response = createNetworkCall().execute()
//
//    println("response is: $response")
//
//    when (response.isSuccessful) {
//    true -> appExecutors.diskIO().execute {
//    saveNetworkCallResult(response.body())
//
//    appExecutors.mainThread().execute {
//    val newDbSource = loadFromDatabase()
//    result.addSource(newDbSource) { newData ->
//    result.removeSource(newDbSource)
//    result.setValue(Resource.success(newData))
//    }
//    }
//    }
//
//    false -> appExecutors.mainThread().execute {
//    result.addSource(dbSource) { newData -> result.setValue(Resource.error(newData, Error(response.code(), response.message()))) }
//    }
//
//    }
//    } catch (exc: IOException) {
//    System.err.println("Make sure your server ${BuildConfig.URL} is running.")
//    appExecutors.mainThread().execute {
//    result.addSource(dbSource) { newData -> result.setValue(Resource.error(newData, Error(503, "Service Unavailable."))) }
//    }
//    }
//    }
//    }
//
//    fun asLiveData(): LiveData<Resource<T>> = result
//
//    @WorkerThread
//    protected abstract fun saveNetworkCallResult(data: T?)
//
//    @MainThread
//    protected abstract fun shouldLoadFromNetwork(data: T?): Boolean
//
//    @MainThread
//    protected abstract fun loadFromDatabase(): LiveData<T>
//
//    @WorkerThread
//    protected abstract fun createNetworkCall(): Call<T>
}
