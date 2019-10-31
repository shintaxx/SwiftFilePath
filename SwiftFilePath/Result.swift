//
//  Result.swift
//  SwiftFilePath
//
//  Created by nori0620 on 2015/01/11.
//  Copyright (c) 2015年 Norihiro Sakamoto. All rights reserved.
//
import Foundation
extension Path {

public enum Result<S, F> {

    case success(S)
    case failure(F)

    public init(success: S) {
        self = .success(success)
    }

    public init(failure: F) {
        self = .failure(failure)
    }

    public var isSuccess: Bool {
        switch self {
            case .success: return true
            case .failure: return false
        }
        
    }

    public var isFailure: Bool {
        switch self {
            case .success: return false
            case .failure: return true
        }
    }

    public var value: S? {
        switch self {
        case .success(let container):
            return container
        case .failure:
            return .none
        }
    }

    public var error: F? {
        switch self {
        case .success:
            return .none
        case .failure(let container):
            return container
        }
    }

    public func onFailure(_ handler: (F) -> Void) -> Path.Result<S,F> {
        switch self {
        case .success:
            return self
        case .failure(let container):
            handler(container)
            return self
        }
    }

    public func onSuccess(_ handler: (S) -> Void) -> Path.Result<S,F> {
        switch self {
        case .success(let container):
            handler(container)
            return self
        case .failure:
            return self
        }
    }

}

}
