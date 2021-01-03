# Swifts-30-Projects - 02

이번에는 스토리 보드에 씬이 하나 뿐이다. `ViewController` 로 구성되어 있다.

뷰가 하나인데 네비게이션 컨트롤러가 달려있어서 네비게이션 컨트롤러를 없앴다.

화면 내에서 사용되는 요소는 타이머 버튼 두개, 시간 보여주는 `UILabel` 두개, 랩스가 보여지는 테이블 뷰가 있다.

## Stopwatch

스탑워치 데이터를 담을 클래스. 

타이머 클래스 하나. 시간을 담을 counter 변수 하나가 있다.

## ViewController

프로퍼티를 보면, 랩스가 표시되는 `UITableView` 하나, timer, lap을 표시하는  `UILabel` .

시작 / 정지 `UIButton` 두개가 있다.

뷰 컨트롤러가 메모리가 올라온 직후인 `viewDidLoad`에서는 다음과 초기 버튼 모양과

배경 색 설정, delegate를 지정한다.

아래는 UI 설정에 대한 부분이다.

자동 회전에 대한 속성을 갖는 `shouldAutoRotate` 메서드가 있더라. 가로 화면은 고려되지 않은 것 같다.

`preferredStatusBarStyle` 는 상단바 스타일이다. `.lightContent` 는 밝은 배경으로 상단바가 덮어 씌어진다. `.darkContent` 는 어두운 배경으로 상단바다가 덮어 씌워진다. 노치가 있는 화면에서는 특히, 기본이 나은 것 같다. 이것은 개인적인 취향으로 변경하였다.

`supportedInterfaceOrientations` 는 화면 회전과 관련된 옵션이다. 새로 화면만 사용하므로 `.portrait` 로 지정해주었다.

앞전에 언급했던 버튼 두개에 대한 액션에 각각

- `@IBAction func playPauseTimer(_ sender: AnyObject)`
- `@IBAction func lapResetTimer(_ sender: AnyObject)`

를 정의하였다.

타이머의 상태는 '시작전', '진행중', '종료' 상태 세가지가 있다. 세가지 상태는 

따라서, 오른쪽의 버튼은 Start, Stop 두가지 중 하나가 표시되고, 왼쪽의 버튼은 비활성 상태, Lap, Rest 세가지의 버튼이 있을 것이다.

### playPauseTimer

Start, Stop 버튼을 수행하는 `@IBAction func playPauseTimer(_ sender: AnyObject)`   먼저 알아보겠다.

`@IBAction` 은 인터페이스 빌더에서 추가한 뷰와 연결한다는 것을 표시한 것이다. 해당 함수에 대해서 자세히 보자. 

비활성화 되었던 `lapResetButton` 을 활성화 한다. 

다음, unwoned은 Timer를 설정할 때에 unowned self로 타깃을 설정하였고, 타이머 두개, 메인 스탑워치, Lap 스탑워치를 설정한다.

```swift
@IBAction func playPauseTimer(_ sender: AnyObject) {
    lapRestButton.isEnabled = true
    
    
    if !isPlay {
      unowned let weakSelf = self
      
      mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
      lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
      
      RunLoop.current.add(mainStopwatch.timer, forMode: RunLoop.Mode.common)
      RunLoop.current.add(lapStopwatch.timer, forMode: RunLoop.Mode.common)
      
      isPlay = true
      changeButton(lapRestButton, title: "Lap", titleColor: UIColor.black)
      changeButton(playPauseButton, title: "Stop", titleColor: UIColor.red)
    } else {
      
      mainStopwatch.timer.invalidate()
      lapStopwatch.timer.invalidate()
      isPlay = false
      changeButton(playPauseButton, title: "Start", titleColor: UIColor.green)
      changeButton(lapRestButton, title: "Reuet", titleColor: UIColor.black)
    }
  }

// MARK: - Extension
fileprivate extension Selector {
  static let updateMainTimer = #selector(ViewController.updateMainTimer)
  static let updateLapTimer = #selector(ViewController.updateLapTimer)
}
```

이와 같은 식으로 구성이 되어 있었는데,   `unowned` 로 `self`를 사용하여 `Timer`의 `target`으로 사용하였다.  타이머가 진행중일때, 타이머가 종료된 상태일때 두가지로 나뉘어 동작한다.

플레이 중이 아닐 때는 main / lap 스탑워치 인스턴스의 Timer를 할당하고 RunLoop를 통해 반복하도록 한다.  아래 부분에 구현되어 있던 `Selector` 의 익스텐션이다. `fileprivate` 를 사용하면 파일 내부에서만 해당 `extension` 이 적용된다. Timer에서는 각각 `updateMainTimer` , `updateLapTimer` 메서드가 반복적으로 실행될 것이다.

`isPlay` 일때는 타이머를 멈추고 버튼 모습을 바꾼다. `Timer.invalidate()` 를 통해 Timer를 종료시킨다.  얼마전 `Bool` 타입에 `toggle()` 메서드가 구현되어 있다는 것이 기억나 toggle로 바꾸어 보긴 했다. 코드마다 다르겠지만, 값을 넣는게 나을 수도 있을 것 같다. 

클로저도 아닌데, target을 왜 unowned로 참조를 시켜준건지 아직 이유를 찾지 못하였다. 처음에는 디버깅을 했을때, leak이 떠서, 아 문제구나 했었는데, 그냥 self일때, unowned self 일때 두번 모두 다 leak이 떴다. 그냥 lldb에서 주소를 보려고 print를 했더니 이것도 어떤 문제가 되었었던 것 같다. 사실 정확한 동작과 구조를 몰라서 이해를 못한 것이라고 생각하고 나중에 다시 한번 코드를 보려고 한다. 

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled.png)

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%201.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%201.png)

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%202.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%202.png)

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%203.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%203.png)

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%204.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%204.png)

### lapResetTimer

Lap 기록과 Reset이 구현된  `@IBAction func lapResetTimer(_ sender: AnyObject)`  메서드이다.

플레이 중이 아닐때 (정지되어있을 때. 종료 상태에는 disbabled 상태이기 때문에) 클릭 시에는 타이머들을 초기화 하고 해당 버튼을 disabled 상태로 전환한다. 

플레이 중일때는 (해당 버튼은 Lap 버튼으로 동작할 것이므로) Lap 기록을 보관하는 배열 `laps` 에 저장하고 화면을 `tableView`를 reload한다. 타이머 또한 초기화 하고 재시작합니다.(동작 방식은 mainStopwatch와 동일함.)

좀 새롭게 봤던건 **Private Helpers** 부분이다

```swift
fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
    button.setTitle(title, for: UIControl.State())
    button.setTitleColor(titleColor, for: UIControl.State())
  }
  
  fileprivate func resetMainTimer() {
    resetTimer(mainStopwatch, label: timerLabel)
    laps.removeAll()
    lapsTableView.reloadData()
  }
  
  fileprivate func resetLapTimer() {
    resetTimer(lapStopwatch, label: lapTimerLabel)
  }
  
  fileprivate func resetTimer(_ stopwatch: Stopwatch, label: UILabel) {
    stopwatch.timer.invalidate()
    stopwatch.counter = 0.0
    label.text = "00:00:00"
  }
  
  @objc func updateMainTimer() {
    updateTimer(mainStopwatch, label: timerLabel)
  }
  
  @objc func updateLapTimer() {
    updateTimer(lapStopwatch, label: lapTimerLabel)
  }
  
  func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
    stopwatch.counter = stopwatch.counter + 0.035
    
    var minutes: String = "\((Int)(stopwatch.counter / 60))"
    if (Int)(stopwatch.counter / 60) < 10 {
      minutes = "0\((Int)(stopwatch.counter / 60))"
    }
    
    var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
    if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
      seconds = "0" + seconds
    }
    
    label.text = minutes + ":" + seconds
  }
```

버튼이 두개, 라벨이 두개이기 때문에 겹치는 기능을 함수로 구현해 두었다. 이렇게 사용하는건 Reference 타입인 클래스(UIButton, UILabel, Stopwatch) 를 매개변수로 넘기기 때문이다. 
(얼마전 class / struct 관련 글을 읽었더니 드디어 차이가 보인다.)

`UILabel`, `Button` 관련 메서드는 `extension`으로 바꿔보는 것도 괜찮다고 생각했다. 그리고, `resetTimer` 메서드에서 해당 메서드의 주가 `UILabel` 일지, `Stopwatch` 일지 고민이 되었다. 이부분은 두개를 분리하는게 나는 더 좋다고 생각했다. 역할이 별개니까..? 

`updateTimer` 메서드는 stopwatch의 값을 가져와 UILabel에 적용하는 메서드이다. Stopwatch  를 모델로 새로 분리해서 사용하면 분리해서 작성할 수 있을 것 같다.

물론, vc하나로도 충분히 괜찮아 보이긴 하지만 공부삼아 수정해 보겠다. (다음 커밋에서 작성)

```swift
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return laps.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier: String = "lapCell"
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

    if let labelNum = cell.viewWithTag(11) as? UILabel {
      labelNum.text = "Lap \(laps.count - (indexPath as NSIndexPath).row)"
    }
    if let labelTimer = cell.viewWithTag(12) as? UILabel {
      labelTimer.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
    }
    
    return cell
  }
}
```

`UITableViewDataSource` 는 tableview에 들어갈 정보를 정의할 때 사용하는 프로토콜이다.

마찬가지로 `tableView.dequeueReusableCell` 를 사용해 셀을 구현한다.

cell의 identifier, cell.viewWithTag을 알아보겠다. identifier 는 IB에서 설정되어 있다.

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%205.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%205.png)

TableViewCell을 이것으로 구분한다. 하여 인터페이스 빌더의 Identifier와 `dequeueReusableCell` 에서 동일한 Identifier로 작성해 주어야 한다.

![Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%206.png](Swifts-30-Projects%20-%2002%206090b5a947464d8f9908922a19f57c83/Untitled%206.png)

내부의 `UIView` 에 접근하기 위해 Tag를 사용한 것을 있다.

또, (`indexPath` as `NSIndexPath`) 로 캐스팅 한 이유를 찾지 못했다. 과거 스위프트 버전에서는 `NSIndexPath`와 브릿지가 되어 있지 않았던 것으로 생각한다.  

---

### Ref

[https://seizze.github.io/2019/12/20/iOS-메모리-뜯어보기,-메모리-이슈-디버깅하기,-메모리-릭-찾기.html](https://seizze.github.io/2019/12/20/iOS-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EB%9C%AF%EC%96%B4%EB%B3%B4%EA%B8%B0,-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%9D%B4%EC%8A%88-%EB%94%94%EB%B2%84%EA%B9%85%ED%95%98%EA%B8%B0,-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EB%A6%AD-%EC%B0%BE%EA%B8%B0.html)