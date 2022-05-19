//
//  Async.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/18.
//

import Foundation

struct Async {
    typealias TaskResultAction = (TaskResult) -> Void
    typealias Task = (@escaping TaskResultAction) -> Void
    
    enum TaskResult {
        case success
        case failure(Error)
    }
    
    static func serial(tasks: [Task], result: @escaping TaskResultAction) {
        serialHelper(tasks: tasks, result: result)
    }
    
    private static func serialHelper(tasks: [Task], result: @escaping TaskResultAction) {
        var tasks = tasks
        
        if tasks.count > 0 {
            let nextTask = tasks.removeFirst()
            
            DispatchQueue.main.async {
                nextTask { taskResult in
                    switch taskResult {
                    case .success:
                        serialHelper(tasks: tasks, result: result)
                    case .failure:
                        result(taskResult)
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                result(.success)
            }
        }
    }
}
