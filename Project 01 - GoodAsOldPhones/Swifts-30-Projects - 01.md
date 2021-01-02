# Swifts-30-Projects - 01

course: Swifts-30-Projects
날짜: Jan 1, 2021
분류: https://www.notion.so/iOS-Swift-093753a0954a4606bc8354d8c71b98b0
수정일: Jan 1, 2021 1:30 PM
시간+분(10진수): 0

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled.png)

# 구조 알아보기

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%201.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%201.png)

처음에 시작은 Tab Bar Controller를 사용했다.

TabViewController는 `UITabBarConrtoller` 를 사용하고 각 탭은 segue를 통해 연결되어 있다.

탭은 `Products` ,  `Us` 탭 두개로 나뉘어져 있으며,  Products 탭은 네비게이션으로 연결되고, Us 탭은 `ContactViewController` 를 만들어 사용하였다.

### ContactViewController

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%202.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%202.png)

`Us` 는 `UIViewController` 를 상속받은 `ContactViewController` 클래스를 이용하여 구현하였고, 내부에 스크롤 뷰를 포함하고 있다. 

내부에는 `viewDidLoad()`, `viewDidLayoutSubviews()` 두가지가 존재한다.

**ViewDidLoad()**

`viewDidLoad` 같은 경우에는 `ViewController` 에서 가장 처음 메모리에 불러올때 동작하는 메서드로 알고 있었다.

**ViewDidLayoutSubviews()**

그런데, `viewDidLayoutSubviews()` 메서드는 언제 동작되는가?

뷰의 사이즈나 위치가 변경되면 레이아웃 정보는 `UIKit` 을 통해 업데이트가 된단다. 레이아웃의 결정 과정 중에 레이아웃과 연관된 부가적인 작업들을 수행할 목적으로 동작한다.

`viewWillLayoutSubviews()` 가 먼저 호출되고,

`layoutSubviews()` 메서드가 호출된다. 이때 뷰 계층 구조를 순회하면서 모든 하위뷰들이 동일한 메서드를 호출하도록 하여 새로운 레이아웃 정보를 계산한다.

마지막으로 `viewDidLayoutSubviews()` 메서드가 호출된다.

해당 코드에는 `viewDidLayoutSubviews()` 를 재정의하여 스크롤 뷰의 위치와 크기를 업데이트 하였다.

해당 코드에서 scrollView의 y좌표가 엣지를 포함한 듯 하여 stackoverflow에서 찾아 추가하였다.

### Products

다음, `Products` 탭은 네비게이션뷰이다. 

`ProductsTableViewController`와 연결된다.

### **ProductsTableViewController**

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%203.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%203.png)

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%204.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%204.png)

처음에 `UITableViewController` 를 구현한  `ProductsTableViewController`  클래스를 사용한다.

제품에 대한 정보는 `products` 프로퍼티에 `[Product]` 형태로 담고 있다.

**viewDidLoad**

해당 단계에서는 Product 데이터를 추가하였다.

**prepare**

`prepare` 메서드는 seuge를 통해서 scene을 전환하기 이전에 호출된다. 해당 시점에서 전환되는 화면 `segue.destination` 에 넘겨야 할 데이터를 설정한다.

여기에서는 각 셀을 눌렀을때 표시될 화면을 미리 설정하였다.

식별하기 위한 Identifier와 Push로 전달한 것은 스토리 보드에서 확인 가능하다.

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%205.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%205.png)

**override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int**

tableView에서 셀들을 표시하기 위해서 개수를 전달받는 메서드, 우리가 사용하는 `products` 프로퍼티의 개수를 전달한다.

**override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell** 

`cellForRowAt` 메서드는 각 셀들이 어떻게 표시되는지를 구현한다.

cell은 대개 `dequeResuableCell(withIdentifier:, for:)` 메서드를 사용하여 가져오게 되는데, 해당 메서드는 반복되는 셀들을 표시할 때, identifier에 해당하는 셀을 재사용하여 보여주게 된다. 셀 개수가 천개라고 천개의 셀을 사용할 공간을 할당하지는 않고      재사용한다는 것.

해당 메서드에서 cell 내부에 들어갈 텍스트, 이미지를 추가한다. 

이미지에서 사용된 `UIImage(naemd:)` 는 Assets.xcassets 에 추가된 이미지 이름을 기반으로 가져온다.

### ProductViewController

이전 테이블 뷰에서 화면을 클릭할 시에 표시된다. 

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%206.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%206.png)

![Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%207.png](Swifts-30-Projects%20-%2001%202f223dd7f28047789c25325c9139dbf9/Untitled%207.png)

네비게이션 컨트롤러를 사용했기 때문에 네비게이션 스택에 쌓이게 되고 좌측 상단에 `Back`  버튼도 확인할 수 있다.

`viewDidLoad()` 에서 이전 화면에서 segue를 통해 전달 받은 Product를  바탕으로 현재 view 내부 `UILabel`와 `UIImageView`를 설정한다. 



### Product

마지막으로 각각 제품을 담는 Product 클래스. 특별 한것은 없고, 제품 이름과 아이콘 이미지, 풀 스크린일 때의 이미지를 담을 수 있다.  클래스로 선언되어 있었지만, 구조체가 더 적합하다고 판단 했다.



아는 만큼, 보이는 만큼 작성해 보았지만, 다음번에는 더 많이 작성할 수 있을 것 같다. 

---

## Ref

`viewDidLayoutSubviews()` 메서드 호출 시점

[레이아웃 결정과 Layout Subviews 관련 메서드](https://oaksong.github.io/2018/03/02/layout-subviews/)