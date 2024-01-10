//
//  LogService.swift
//  IIQ-IOS-Agent-Example
//
//  Created by Julian Rassolov on 24/12/2023.
//

import Foundation

public class IIQLogService: ObservableObject {
    public static let shared = IIQLogService()
    
    @Published public var log:String?
    
    private var loggerMode: IIQLoggerMode
    
    private init() {
        self.log = ""
        loggerMode = .NONE
    }
    
    public func setLoggerMode(mode:IIQLoggerMode){
        self.loggerMode = mode;
    }
    
    public func Log(_ msg: String) {
        DispatchQueue.main.async {
            switch self.loggerMode {
            case .BOTH, .EXTERNAL :
                if let unwrappedLog = self.log {
                    self.log = unwrappedLog + "\n\(msg)"
                } else {
                    self.log = "\n\(msg)"
                }
                fallthrough
            case .BOTH, .INTERNAL:
                print(msg)
                
            case .NONE:
                return
            }
        }
    }
    
}

