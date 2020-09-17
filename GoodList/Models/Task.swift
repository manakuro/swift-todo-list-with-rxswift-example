//
//  Task.swift
//  GoodList
//
//  Copyright © 2020 manato. All rights reserved.
//

import Foundation

enum Priority: Int {
  case high, medium, low
}

struct Task {
  let title: String
  let priority: Priority
}
