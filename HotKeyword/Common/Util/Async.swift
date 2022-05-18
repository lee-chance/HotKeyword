//
//  Async.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/18.
//

import Foundation

class Async {
    typealias Task = (@escaping (Error?) -> Void) -> Void
    
    static func serial(tasks: [Task], result: @escaping (Error?) -> Void) {
        serialHelper(tasks: tasks, result: result)
    }
    
    private static func serialHelper(tasks: [Task], result: @escaping (Error?) -> Void) {
        var tasks = tasks
        
        if tasks.count > 0 {
            let nextTask = tasks.removeFirst()
            DispatchQueue.main.async {
                nextTask { error in
                    if error == nil {
                        serialHelper(tasks: tasks, result: result)
                    } else  {
                        result(error)
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                result(nil)
            }
        }
    }
    
}
