# Swifts-30-Projects - 21



<img src="image_asset/Untitled.png" alt="image_asset/Untitled.png" style="zoom:33%;" />

웹 컨텐츠를 보여주는 하나의 `ViewController`로 이루어져 있는 어플리케이션이다.

## Storyboard

<img src="image_asset/Untitled%201.png" alt="image_asset/Untitled%201.png" style="zoom:33%;" />

WebView가 존재하고, WebView 위로 url을 입력할 수 있는 textfield가 존재한다.

Interface Builder에서 생성한 `WKWebView` 인스턴스가 존재하고, `Back`, `Forward`, `Reload` 버튼이 하단 `toolBar`에 존재한다.

## ViewController

### viewDidLoad

먼저 textField (주소창)의 delegate, webView.navigationDelegate 를 지정한다.

이후에 옵저빙을 정의하는데, KVO 패턴을 이용하여 webView 인스턴스의 loading, estimatedProgress 프로퍼티 값의 변화를 감지한다.

webView 객체 내부에 "loading", "estimatedProgress" 을 key로 observing을 추가한다.

### override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)

KVO 패턴을 이용해서 옵저빙을 수행할 때에 호출되는 함수이다. `addObserver`를 이용해 추가한 프로퍼티에 변경이 일어났을 때, 해당 함수가 호출된다.

keyPath("loading", "estimatedProgress") 에 따라 다른 동작을 수행한다. webView 내부 estimatedProgress에 따라 ViewController 내부 progressBar를 변경하고, loading 될때, backButton, forwardButton 의 enable 상태를 변경한다.

## extension ViewController: WKNavigationDelegate

iOS에서 웹을 표시할때 사용하는 `WKWebView` 객체의 navigation 부분을 위임받아 구현한다.

### func webView(_:,didFailProvisionalNavigation:,withError:)

해당 함수는 navigation process에서 에러가 발생했을 때 호출된다.

`UIAlertController`를 이용하여 에러 메시지 내용을 alert로 표시한다.

### func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)

navigation이 종료되었을 때에 호출된다. textField (주소창)에 주소를 변경하고, `progressBar`를 수정한다.

## extension ViewController: UITextFieldDelegate

textField 에서 구현되어야 하는 기능을 위임받아 구현한다. (주소창)

### func textFieldShouldReturn(_ textField: UITextField) -> Bool

return 버튼이 눌렸을 때에 호출된다.

`webView.load(_:)` 함수를 이용해  textField의 주소를 이용해 웹 컨텐츠를 요청한다.

## extension WKWebView

### func load(_ urlString: String)

문자열을 이용해 웹 컨텐츠를 불러오는 함수이다. 

문자열을 이용해 URLRequest를 생성하고, `load(_:)` 함수를 이용해 웹 컨텐츠를 불러온다.