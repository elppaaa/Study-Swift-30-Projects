# Swifts-30-Projects - 03



이번에는 스토리보드가 없다. 

화면을 구상할때에 (SwiftUI 제외) `Interface Builder` 를 이용하는 방법과 `UIViewController`  내부에서  `subView`를 정의하는 법 두가지가 있다.  각자 장단점이 존재한다. `Interface Builder`는 한눈에 앱 디자인을 확인할 수 있지만 유지 보수 측면에서 어려움이 있고, Inspector를 통해 어떤 옵션을 설정했는지를 하나하나 확인해야 하는 어려움이 있다. 

후자는 옵션을 하나하나 작성해 주어야 하고, 수정한 내역을 확인해 보려면 시뮬레이터를 돌려 직접 확인해야 한다는 번거로움이 있다. (수정 후 Build를 재 실행해줘야 하는 것이 큰 문제인데, 이것은 Injection으로 해결 가능하다.) 하지만 후자를 사용하면 코드를 관리하듯이 UI의 어떤 부분이 바뀌었는지 변경점은 Storyboard보다 훨씬 직관적으로 확인할 수 있다. (Storyboard는 코드로 읽기에는 좋지 않다.) 이어 유지보수 측면에서도 훨씬 장점이 있다고 생각한다. 

하여, 해당 프로젝트는 이전까지 사용하던 `Main.Storyboard` 파일은 존재하지 않는다.  App의 LifeCycle을 관리하는 `AppDelegate`를 확인해보면  애플리케이션이 실행 시(`application(_:,didFinishLaunchingWithOptions:) -> Bool`)에서 `rootViewControlller` 를 `FBMeViewController` 클래스로 설정해 둔것을 확인할 수 있다. 

하면 앱 실행시에 `FBMeViewController` 가 가장 먼저 표시될 것이다.

# 구조

먼저 폴더 구조를 확인해보면, 폴더는 `Helper`, `ViewController`, `View`, `Model` 폴더로 이루어져 있다.

## Helper

**Specs**

Helper에는 Android에서 `R` 로 리소스를 접근하는 것과 같이 사용할 값을 상수로 정의해 두었다. 이것은 Identifier 같이 값들을 문자열로 넘겨주는 대신 사용할 수 있어 오타를 예방할때, 유용하다고 생각한다.  이곳에서 사용할 color, font, image asset 들을 미리 정의해 두었다. 일관성 있게, 혹은 수정할 때에 유용할 것이다.

`UIColor+Extension.swift` 에서는 UIColor에서 hex 나 rgb를 편하게 사용할 수 있도록 정의해 두었다.

`TableKeys` 에서는 tableView에서 사용할 데이터들을 미리 정의해 둔 것 같다. `FBMeUser` 모델을 인자로 받아 2차원 배열을 반환한다.

`populate` 메서드를 사용해서 user에 맞게 tableView의 dataSource를 생성해서 반환한다.

딕셔너리 구조로 저장하는 것을 알 수 있다.

## Model

### FBMeUser

사용자 정보를 갖는 클래스이다. 프로퍼티와 initializer만 사용한다.

## ViewController

`FBMeBaseViewController`와 이것을 상속받는 `FBMeViewController` 두개가 존재한다.

공통적으로 모든 `UIViewController`에서 적용 되어야 하는 기능을 `FBMeBaseViewController`에서 정의하고 이것을 `FBMeViewController`에서 모습을 구현한다. 

`FBMeBaseViewController` 에서는 다른 기능은 구현해 두지 않았고 배경 색만 바꾸었다.

### FBMeViewController

`FBMeViewController`  에서는 `FBMeBaseViewController` 만 구현해 두었고, 다른 부분은 구현해두지 않았다.

`RowModel` 로 딕셔너리 하나를 typealias 해 두었다. typealias로 정의해 둔 것이 새로웠다. 

computed property로 `user`, `tableViewDataSource`를 정의해 두었다.

`user`는 앞전에 확인했던 `FBMeUser` 클래스를 반환하고, `tableViewDataSource` 는 테이블 뷰에 사용할 데이터를 제공한다. (`TableKeys` 를 사용하였다.)

`tableView` 를 선언하였다. 클로저를 사용하여 감쌌고, 사용할 셀의 모습을 `register` 메서드를 통해 등록하였다.

### viewDidLoad

먼저, `title` , `navigationBar` tint color를 설정하였다.

`tableView` 의 `dataSource`, `delegate`를 설정한다.

`view`(ViewController의 뷰)에 tableView를 추가하고, `constraints` 를 설정한다. 레이아웃을 설정할때 `withVisualFormat` 매개변수를 사용하여 설정하였는데, 문법을 이해하지 못해 처음에 조금 난해하였다. `H:|-0-[tableView]-0-|`, `V:|-0-[tableView]-0-|` view에서 tableView로 constant 0으로 제약을 준 것이고,  H는 Horizontal, V는 Vertical을 의미할 것이다. 해당 방식이 좋은지, 하나하나 제약을 주는 방식이 더 자주 쓰는지 모르겠지만 읽을줄은 알아야 할 것이다.

### rows, title, rowModel

`rows` 메서드는 dataSource를 담당하는 `tableViewDataSource` 에서 해당 section에 해당하는 2차원 배열을 가져온다. 

`title` 메서드는 dataSource에서 section에 해당하는 title을 가져온다.

`rowModel` 은 아까 typealias로 지정한 `RowModel` 타입으로 `indexPath.section`의 `indexPath.row`로 가져온다. 항상 하나의 section만 사용했었던 터라 section의 정체를 모르고 있었다..

하여 dataSource로 사용되는 `TableKeys`도 `row`들을  `section` 단위로 구분지어 3차원의 배열로 만들어 두었다는 것을 알 수 있었다. 

### extension FBMeViewController: UITableViewDataSource

extension을 이용하 `UITableViewDataSource` 를 분리해 두었다. 처음에는 `extension` 이 굳이 필요한 것인가 생각했는데, 하나의 클래스를 분리해서 작성 수 있다는 것은 큰 장점이다.

사용할 테이터 / 섹션, row의 개수를 출력하고 Header와 셀 내부 데이터를 설정한다.

`tableView(_:cellForRowAt:)` 만 보자면, 

`rowModel` 메서드를 통해 각 row를 가져와 cell의 title을 설정한다.

cell의 모습이나 색을 바꿔야 하는 경우를 적절히 처리하는 과정 또한 담겨있다.

### extension FBMeViewController: UITableViewDelegate

`tableView(_:heightForRowAt:)` 에서 cell의 종류에 따라 높이를 다르게 변경한다.

`tableView(_:willDisplay:forRowAt:)` 에서는 테이블 뷰의 색을 지정하였다.

`talbeView(_:cellForRowAt:)` , `tableView(_:willDisplay:forRowAt:)` 의 차이

가장 먼저 `UITableViewCell` 에 있는 `awakeFromNib` 이 먼저 호출되고, `talbeView(_:cellForRowAt:)` 가 실행된다. 그 다음에 해당 셀을 그리기 직전에 

`tableView(_:willDisplay:forRowAt:)` 가 실행된다.

: LifeCycle에 따라서 적절히 정의하면 됨.

## View

### FBMeBaseCell

`FBMeViewController` 에서 사용할 `tableView`의 cell 모습을 정의한다.

`identifier` 를 문자열로 미리 정의해 두었다.

`init` 에서는 스타일을 `.default` 로 지정하였다.

`awakeFromNib` 을 오버라이딩하였다. `backgroundColor` , `textLabel`, `detailTextLabel` 을 설정한다. `.default` 스타일이여서 레이아웃은 따로 설정하지 않은 것 같다.

---

### Ref

- tableView LifeCycle: [https://jinnify.tistory.com/58](https://jinnify.tistory.com/58)