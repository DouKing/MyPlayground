//===----------------------------------------------------------*- Swift -*-===//
//
// Created by wuyikai on 2024/5/23.
// Copyright © 2024 wuyikai. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation

enum AudioToolboxError: Error {
    case invalidPath
    case runtime(OSStatus, String)
}
