//
//  ViewController.swift
//  Stopwatch
//
//  Copyright © 2016 YiGu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
  // MARK: - Variables
  fileprivate let mainStopwatch: Stopwatch = Stopwatch()
  fileprivate let lapStopwatch: Stopwatch = Stopwatch()
  fileprivate var isPlay: Bool = false
  fileprivate var laps: [String] = []
  var mainObserver: NSKeyValueObservation?
  var lapObserver: NSKeyValueObservation?
  
  // MARK: - UI components
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var lapTimerLabel: UILabel!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var lapRestButton: UIButton!
  @IBOutlet weak var lapsTableView: UITableView!
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let initCircleButton: (UIButton) -> Void = { button in
      button.layer.cornerRadius = 0.5 * button.bounds.size.width
      button.backgroundColor = .white
    }
    
    initCircleButton(playPauseButton)
    initCircleButton(lapRestButton)
    
    lapRestButton.isEnabled = false
    lapsTableView.delegate = self;
    lapsTableView.dataSource = self;
    
    mainObserver = mainStopwatch.observe(\.counter, options: [.new], changeHandler: { (stopwatch, value) in
      if let value = value.newValue {
        self.timerLabel.updateStopwatchLabel(from: value)
      }
    })
    
    lapObserver = lapStopwatch.observe(\.counter, options: [.new], changeHandler: { (stopwatch, value) in
      if let value = value.newValue {
        self.lapTimerLabel.updateStopwatchLabel(from: value)
      }
    })
  }
  
  // MARK: - UI Settings
  override var shouldAutorotate : Bool { false }
  
  override var preferredStatusBarStyle : UIStatusBarStyle { .default }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask { .portrait }
  
  // MARK: - Actions
  @IBAction func playPauseTimer(_ sender: AnyObject) {
    lapRestButton.isEnabled = true
    
    
    if !isPlay {
      mainStopwatch.setTimer()
      lapStopwatch.setTimer()
      
      isPlay = true
      playPauseButton.changeLabel("Stop", color: .red)
      lapRestButton.changeLabel("Lap", color: .black)
    } else {
      isPlay = false
      playPauseButton.changeLabel("Start", color: .green)
      lapRestButton.changeLabel("Reset", color: .black)
      
      mainStopwatch.invalidate()
      lapStopwatch.invalidate()
    }
  }
  
  @IBAction func lapResetTimer(_ sender: AnyObject) {
    if !isPlay {
      mainStopwatch.removeTimer()
      lapStopwatch.removeTimer()
      
      laps.removeAll()
      lapsTableView.reloadData()
      
      lapRestButton.changeLabel("Lap", color: .lightGray)
      lapRestButton.isEnabled = false
    } else {
      if let timerLabelText = timerLabel.text {
        laps.append(timerLabelText)
      }
      lapsTableView.reloadData()
      lapStopwatch.resetTimer()
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return laps.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier: String = "lapCell"
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    
    if let labelNum = cell.viewWithTag(11) as? UILabel {
      labelNum.text = "Lap \(laps.count - indexPath.row)"
    }
    if let labelTimer = cell.viewWithTag(12) as? UILabel {
      labelTimer.text = laps[laps.count - indexPath.row - 1]
    }
    
    return cell
  }
}

// MARK: - Extension
fileprivate extension UIButton {
  func changeLabel(_ title: String, color titleColor: UIColor) {
    self.setTitle(title, for: UIControl.State())
    self.setTitleColor(titleColor, for: UIControl.State())
  }
}

fileprivate extension UILabel {
  func updateStopwatchLabel(from counter: Double) {
    var minutes: String = "\((Int)(counter / 60))"
    if (Int)(counter / 60) < 10 {
      minutes = "0\((Int)(counter / 60))"
    }
    
    var seconds: String = String(format: "%.2f", (counter.truncatingRemainder(dividingBy: 60)))
    if counter.truncatingRemainder(dividingBy: 60) < 10 {
      seconds = "0" + seconds
    }
    
    self.text = minutes + ":" + seconds
  }
}
