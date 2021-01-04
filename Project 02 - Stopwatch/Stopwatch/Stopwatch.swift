//
//  Stopwatch.swift
//  Stopwatch
//
//  Copyright © 2016 YiGu. All rights reserved.
//

import Foundation

class Stopwatch: NSObject {
  @objc dynamic var counter: Double
  var timer: Timer
  
  override init() {
    counter = 0.0
    timer = Timer()
  }
}

//MARK: - StopWatch+Model
extension Stopwatch {
  func setTimer() {
    unowned let weakSelf = self
    timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    
  }
  
  func invalidate() {
    timer.invalidate()
  }
  
  @objc func updateTimer() {
    counter += 0.035
  }
  
  func removeTimer() {
    timer.invalidate()
    counter = 0.0
  }
  
  func resetTimer() {
    timer.invalidate()
    counter = 0.0
    setTimer()
  }
}
