PinAuto 为在 iOS 开发中使用 AutoLayout 提供了方便的写法.


[![CI Status](http://img.shields.io/travis/banxi1988/PinAuto.svg?style=flat)](https://travis-ci.org/banxi1988/PinAuto)
[![Version](https://img.shields.io/cocoapods/v/PinAuto.svg?style=flat)](http://cocoapods.org/pods/PinAuto)
[![License](https://img.shields.io/cocoapods/l/PinAuto.svg?style=flat)](http://cocoapods.org/pods/PinAuto)
[![Platform](https://img.shields.io/cocoapods/p/PinAuto.svg?style=flat)](http://cocoapods.org/pods/PinAuto)



```swift
import PinAuto

class MyViewController:UIViewController{
  lazy var box = UIView()

  override func loadView() {
    super.loadView()
    self.view.addSubview(box)
    box.pa_width.eq(100).install()
    box.pa_height.eq(100).install()
    box.pa_centerX.install()
    box.pa_centerY.install()
  }

}
```

## 使用
要运行示例项目,先 clone 此项目,然后先在 `Example` 目录执行 `pod install` 命令.

## 安装
PinAuto 支持(同时推荐)通过[CocoaPods](http://cocoapods.org)安装 .
在你的 Podfile 中加入下面一行即可:

```ruby
pod "PinAuto"
```


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

PinAuto is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PinAuto"
```

## Author

banxi1988, banxi1988@gmail.com

## License

PinAuto is available under the MIT license. See the LICENSE file for more info.
