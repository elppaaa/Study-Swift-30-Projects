# Swifts-30-Projects - 14

로딩중임을 나타내는 듯한 애니메이션이 표시되는 프로젝트이다.

스토리 보드 하나와 ViewController 하나로 이루어져 있다.

<img src="image_asset/Untitled.png" alt="image_asset/Untitled.png" style="zoom:33%;" />

## ViewController

스토리보드에서 그린 3개의 점을 `@IBOutlet` 을 이용해 프로퍼티로 가져왔다.

### startAnimation()

애니메이션을 수행한다. 3개의 점 `imageView` 를 `CGAffineTransform` 클래스를 이용해 작아진 크기로 지정한다.

`UIView.animate` 함수를 이용해 원래 크기로 되돌아왔다가 작아졌다를 반복하도록 한다. delay를 0.2초씩 주었고, option에서 `[.repeat, .autoreverse]` 를 주어 커졌다 작아졌다를 반복하도록 한다.