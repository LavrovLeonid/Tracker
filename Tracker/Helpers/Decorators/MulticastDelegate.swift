//
//  MulticastDelegate.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/15/24.
//

import Foundation

@propertyWrapper struct Multicast<T> {
    
    private var _wrappedValue: MulticastDelegate<T> = .init()
    var projectedValue: MulticastDelegate<T> { _wrappedValue }

    var wrappedValue: T {
        get { fatalError("Should not be accessed directly") }
        set { _wrappedValue.add(newValue) }
    }
    
    init() {}
}

final class MulticastDelegate<T> {
    let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects {
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }
    
    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }
}
