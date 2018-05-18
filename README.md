# HjzCarouselView
适用于 Swift 的轮播图库。

支持代码、xib、Storyboard。

## 安装

```ruby
pod 'HjzCarouselView'
```

## 使用

传入字符串数组，会自动识别是网络图片还是本地图片，可以网络图片和本地图片混搭，优先加载本地图片。

使用的是 Kingfisher 框架加载网络图片。图片是要通过 https 认证的，如果不是，请自行添加图片的域名到 info.plist 白名单中。

先配置好参数，在设置 `style`，设置 `style` 样式后开始触发轮播图。

### 图片模式：

```swift
let headerView = CarouselView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 230))

/// 设置图片内容模式
headerView.imgContentMode = .scaleAspectFill
/// 设置图片数组
headerView.style = .image(["ydms1",
                           "ydms2",
                           "https://www.google.cn/chrome/assets/common/images/marquee/benefits-4.jpg",
                           "https://www.google.cn/chrome/assets/common/images/marquee/benefits-5-mobile.png",
                           "ydms3"])
view.addSubview(headerView)
```

### 头条模式

```swift
let headline = CarouselView(frame: CGRect(x: 0, y: headerView.frame.maxY + 40, width: view.frame.width, height: 44))

/// 头条标题初始 x，默认 0
headline.lineOffsetX = 5
/// 限制头条的显示行数，0表示不限制，默认1
headline.numberOfLines = 1
/// 头条字体大小，默认12
headline.fontSize = 12
/// 设置头条数组
headline.style = .label(["“迎风一刀斩”，常山药业跌停！网红公司高管神操作，让韭菜情何以堪",
                         "Google Chrome 将从9月开始，默认 HTTPS ...",
                         "北约军人在乌克兰顿巴斯地区遇爆炸 至少3死2伤",
                         "[图]Chrome将逐步移除绿色小锁和“Secure”标记"])
view.addSubview(headline)
```

