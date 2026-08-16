# HImageTextView

HImageTextView 是一个功能强大的 iOS 自定义视图类，集成了图片展示、文本显示、交互处理等多种功能，支持链式调用 API，提供了丰富的配置选项。

## 功能特性

### 1. 核心功能
- **图文组合**：支持图片和文本的多种布局方式
- **交互功能**：支持点击、长按、双击、滑动、拖拽等手势
- **状态管理**：支持 normal、disabled、selected、highlighted、loading 等多种状态
- **图片加载**：支持网络图片和本地图片加载，集成 Kingfisher 进行缓存
- **背景图片**：支持设置背景图片，可独立配置
- **渐变背景**：支持设置渐变色背景

### 2. 布局选项
- **图片位置**：支持 top、left、bottom、right、center、leadingTop
- **图片大小**：可自定义图片尺寸
- **图片间距**：可自定义图片与文本的间距
- **文本属性**：支持设置字体、颜色、对齐方式、行数等

### 3. 外观定制
- **圆角**：支持设置视图圆角、图片圆角、背景图片圆角
- **边框**：支持设置边框宽度和颜色
- **阴影**：支持设置阴影颜色、偏移、透明度和半径
- **图片处理**：支持图片模糊、亮度、饱和度、对比度调整

### 4. 动画效果
- **点击动画**：支持点击时的缩放和透明度变化
- **加载动画**：支持加载指示器的显示和隐藏动画

### 5. 可访问性
- **VoiceOver 支持**：提供完整的 VoiceOver 支持，包括标签、提示和特性

## 安装

### 依赖
- **SnapKit**：用于自动布局
- **Kingfisher**：用于图片加载和缓存

### 安装方法
1. 使用 CocoaPods 安装依赖：
   ```bash
   pod 'SnapKit'
   pod 'Kingfisher'
   ```

2. 将 HWebClasses 文件夹添加到项目中

## 使用示例

### 基本使用

```swift
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建基本的图文组合视图
        let compositeView = HImageTextView(frame: CGRect(x: 50, y: 100, width: 200, height: 100))
            .text("Hello HWeb")
            .textColor(.black)
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
            .cornerRadius(8)
            .borderWidth(1)
            .borderColor(.lightGray)
        
        // 设置本地图片
        compositeView.setImage(WithName: "icon")
        
        // 设置点击事件
        compositeView.pressed = {
            print("Composite view pressed")
        }
        
        view.addSubview(compositeView)
    }
}
```

### 网络图片加载

```swift
let compositeView = HImageTextView(frame: CGRect(x: 50, y: 250, width: 200, height: 100))
    .text("Network Image")
    .imageSize(CGSize(width: 44, height: 44))
    .imagePosition(.left)

// 设置网络图片
compositeView.setImageUrlString("https://example.com/image.jpg")

// 设置图片加载状态回调
compositeView.imageLoadStatus = { sender, status, error in
    switch status {
    case .loading:
        print("Image loading...")
    case .success:
        print("Image loaded successfully")
    case .failure:
        print("Image loaded failed: \(error?.localizedDescription ?? \"")")
    }
}

view.addSubview(compositeView)
```

### 手势支持

```swift
let gestureView = HImageTextView(frame: CGRect(x: 50, y: 400, width: 200, height: 100))
    .text("Gestures Example")
    .imageSize(CGSize(width: 44, height: 44))
    .imagePosition(.left)

// 设置点击事件
gestureView.pressed = {
    print("Tapped")
}

// 设置长按事件
gestureView.longPressed = {
    print("Long pressed")
}

// 设置双击事件
gestureView.doubleTapped = {
    print("Double tapped")
}

// 设置滑动事件
gestureView.swiped = { sender, direction in
    switch direction {
    case .right:
        print("Swiped right")
    case .left:
        print("Swiped left")
    case .up:
        print("Swiped up")
    case .down:
        print("Swiped down")
    default:
        break
    }
}

// 设置拖拽事件
gestureView.dragged = { sender, translation, velocity in
    print("Dragged: \(translation), Velocity: \(velocity)")
}

view.addSubview(gestureView)
```

### 复杂布局

```swift
// 图片居中布局
let centerView = HImageTextView(frame: CGRect(x: 50, y: 550, width: 200, height: 200))
    .text("Center Image")
    .imageSize(CGSize(width: 80, height: 80))
    .imagePosition(.center)
    .cornerRadius(10)
    .borderWidth(1)
    .borderColor(.lightGray)

centerView.setImage(WithName: "logo")
view.addSubview(centerView)

// 文字环绕布局
let wrapView = HImageTextView(frame: CGRect(x: 50, y: 780, width: 250, height: 100))
    .text("This is a long text that will wrap around the image. It demonstrates the text wrap layout option.")
    .textNumberOfLines(0)
    .imageSize(CGSize(width: 60, height: 60))
    .imagePosition(.leadingTop)
    .cornerRadius(8)
    .borderWidth(1)
    .borderColor(.lightGray)

wrapView.setImage(WithName: "icon")
view.addSubview(wrapView)
```

### 状态管理

```swift
let stateView = HImageTextView(frame: CGRect(x: 50, y: 920, width: 200, height: 100))
    .text("State Example")
    .imageSize(CGSize(width: 44, height: 44))
    .imagePosition(.left)
    .cornerRadius(8)
    .borderWidth(1)
    .borderColor(.lightGray)

stateView.setImage(WithName: "icon")
view.addSubview(stateView)

// 切换状态
stateView.state = .selected  // 选中状态
// stateView.state = .disabled  // 禁用状态
// stateView.state = .highlighted  // 高亮状态
// stateView.state = .loading  // 加载状态
```

### 渐变背景

```swift
let gradientView = HImageTextView(frame: CGRect(x: 50, y: 1070, width: 200, height: 100))
    .text("Gradient Background")
    .textColor(.white)
    .imageSize(CGSize(width: 44, height: 44))
    .imagePosition(.left)
    .cornerRadius(8)

// 设置渐变背景
gradientView.gradientBackgroundColors = [
    UIColor.blue.cgColor,
    UIColor.purple.cgColor
]
gradientView.gradientStartPoint = CGPoint(x: 0, y: 0)
gradientView.gradientEndPoint = CGPoint(x: 1, y: 1)

gradientView.setImage(WithName: "icon")
view.addSubview(gradientView)
```

## API 参考

### 链式调用方法

#### 文本相关
- `text(_:)` - 设置文本内容
- `textColor(_:)` - 设置文本颜色
- `textFont(_:)` - 设置文本字体
- `textNumberOfLines(_:)` - 设置文本行数
- `textAlignment(_:)` - 设置文本对齐方式

#### 图片相关
- `image(_:)` - 设置图片
- `setImage(WithName:)` - 设置本地图片
- `setImageUrlString(_:)` - 设置网络图片
- `imageSize(_:)` - 设置图片大小
- `imageSpace(_:)` - 设置图片与文本的间距
- `imagePosition(_:)` - 设置图片位置
- `renderColor(_:)` - 设置图片渲染颜色

#### 外观相关
- `cornerRadius(_:)` - 设置视图圆角
- `borderWidth(_:)` - 设置边框宽度
- `borderColor(_:)` - 设置边框颜色
- `shadowColor(_:)` - 设置阴影颜色
- `shadowOffset(_:)` - 设置阴影偏移
- `shadowOpacity(_:)` - 设置阴影透明度
- `shadowRadius(_:)` - 设置阴影半径

#### 状态相关
- `state(_:)` - 设置视图状态

#### 动画相关
- `animationDuration(_:)` - 设置动画时长
- `useTapAnimation(_:)` - 设置是否使用点击动画
- `tapAnimationScale(_:)` - 设置点击动画缩放比例
- `tapAnimationAlpha(_:)` - 设置点击动画透明度

#### 加载指示器相关
- `activityIndicatorStyle(_:)` - 设置加载指示器样式
- `activityIndicatorColor(_:)` - 设置加载指示器颜色
- `activityIndicatorSize(_:)` - 设置加载指示器大小
- `activityIndicatorPosition(_:)` - 设置加载指示器位置
- `loadingText(_:)` - 设置加载时的文本提示

### 回调属性

- `pressed` - 点击回调
- `longPressed` - 长按回调
- `doubleTapped` - 双击回调
- `swiped` - 滑动回调
- `dragged` - 拖拽回调
- `didGetError` - 图片加载错误回调
- `didGetImage` - 获取图片回调
- `imageLoadStatus` - 图片加载状态回调

## 注意事项

1. **依赖管理**：确保项目中已安装 SnapKit 和 Kingfisher
2. **图片资源**：使用本地图片时，确保图片已添加到项目中
3. **网络权限**：使用网络图片时，确保项目已添加网络权限
4. **性能优化**：对于大量使用 HImageTextView 的场景，建议使用图片预加载功能

## 版本历史

- **1.0.0** - 初始版本，支持基本的图文组合和交互功能
- **1.1.0** - 添加滑动和拖拽手势支持
- **1.2.0** - 添加图片居中、文字环绕等布局选项
- **1.3.0** - 优化性能，添加渐变背景支持
- **1.4.0** - 增强可访问性支持

## 许可证

MIT License
