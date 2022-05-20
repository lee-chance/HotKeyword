//
//  Logger.swift
//
//
//  Created by 이창수
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

struct Logger {
    static var logFilePath :String?
    
    static var minLogLevel: Logger.Level {
        #if DEBUG
        return .trace
        #else
        return .info
        #endif
    }
    
    static var maxLogLevel: Logger.Level {
        #if DEBUG
        return .critical
        #else
        return .warning
        #endif
    }
    
    private static func handleLog(level: Logger.Level, message: String, context: Logger.Context) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        dateFormatter.timeZone = .current // 현재 timezone (한국)
        dateFormatter.locale = Locale(identifier: "ko") // 오전/오후
        let now =  dateFormatter.string(from: Date())
        
        let fileMessage = "\(now) \(context.description)\(level.logIcon) \(message)"
        Crashlytics.crashlytics().log(fileMessage)
        
        if Logger.minLogLevel <= level, level <= Logger.maxLogLevel {
            print(fileMessage)
            
//            #if DEBUG
//            writeLogIntoFile(fileMsg)
//            #endif
        }
    }
    
//    static func cachedPath(_ fileName: String) -> String? {
//        if logFilePath == nil {
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent(fileName)
//            logFilePath = fileURL.path
//        }
//
//        return logFilePath
//    }
//
//    static func writeLogIntoFile(_ s: String) {
//        guard let path = Logger.cachedPath("dump.txt") else {
//            print("failed to make file")
//            return
//        }
//
//        var dump = ""
//        if FileManager.default.fileExists(atPath: path) {
//            dump =  try! String(contentsOfFile: path, encoding: .utf8)
//        }
//        do {
//            // Write to the file
//            try  "\(dump)\n\(s)".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
//        } catch let error as NSError {
//            print("Failed writing to log file: \(path), Error: " + error.localizedDescription)
//        }
//    }
}

extension Logger {
    static func trace(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .trace, message: str.description, context: context)
    }
    
    static func debug(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .debug, message: str.description, context: context)
    }
    
    static func info(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .info, message: str.description, context: context)
    }
    
    static func notice(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .notice, message: str.description, context: context)
    }
    
    static func warning(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .warning, message: str.description, context: context)
    }
    
    static func error(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .error, message: str.description, context: context)
    }
    
    static func critical(_ str: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .critical, message: str.description, context: context)
    }
}

extension Logger {
    private struct Context {
        let file: String
        let function: String
        let line: Int
        
        var description: String {
            "\(file):\(function):\(line):"
        }
    }
}

extension Logger {
    /// The log level.
    ///
    /// 가장 낮은 trace레벨부터 가장 높은 critical이 있습니다.
    enum Level: String, Codable, CaseIterable {
        /// 👣 TRACE
        ///
        /// Appropriate for messages that contain information normally of use only when
        /// tracing the execution of a program.
        ///
        /// 프로그램 실행을 추적하는 경우에만 일반적으로 사용되는 정보가 포함된 메시지에 적합합니다.
        case trace
        
        /// 💬 DEBUG
        ///
        /// Appropriate for messages that contain information normally of use only when
        /// debugging a program.
        ///
        /// 프로그램을 디버깅할 때만 일반적으로 사용되는 정보를 포함하는 메시지에 적합합니다.
        case debug
        
        /// ℹ️ INFO
        ///
        /// Appropriate for informational messages.
        ///
        /// 정보 메시지에 적합합니다.
        case info
        
        /// 📢 NOTICE
        ///
        /// Appropriate for conditions that are not error conditions, but that may require
        /// special handling.
        ///
        /// 오류 상태는 아니지만 특별한 취급이 필요할 수 있는 조건에 적합합니다.
        case notice
        
        /// ⚠️ WARNING
        ///
        /// Appropriate for messages that are not error conditions, but more severe than
        /// `.notice`.
        ///
        /// 오류 상태는 아니지만 `.notice`보다 심각한 메시지에 적합합니다.
        case warning
        
        /// ‼️ ERROR
        ///
        /// Appropriate for error conditions.
        ///
        /// 에러 상태에 적합합니다.
        case error
        
        /// 🔥 CRITICAL
        ///
        /// Appropriate for critical error conditions that usually require immediate
        /// attention.
        ///
        /// 일반적으로 즉각적인 주의가 필요한 심각한 오류 상황에 적합합니다.
        case critical
    }
}

extension Logger.Level {
    fileprivate var logIcon: String {
        switch self {
        case .trace:    return "[👣]"
        case .debug:    return "[💬]"
        case .info:     return "[ℹ️]"
        case .notice:   return "[📢]"
        case .warning:  return "[⚠️]"
        case .error:    return "[‼️]"
        case .critical: return "[🔥]"
        }
    }
    
    private var naturalIntegralValue: Int {
        switch self {
        case .trace:    return 0
        case .debug:    return 1
        case .info:     return 2
        case .notice:   return 3
        case .warning:  return 4
        case .error:    return 5
        case .critical: return 6
        }
    }
}

extension Logger.Level: Comparable {
    public static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
        return lhs.naturalIntegralValue < rhs.naturalIntegralValue
    }
}
