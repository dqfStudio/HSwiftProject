# HTextFieldView 使用指南

## 概述

**HTextFieldView** 是一个组合模式（UIView 容器 + UITextField 子控件）实现的输入框组件。

### 核心设计

1. **链式配置** — 通过 `config { c in ... }` 统一配置，类似 SnapKit 风格
2. **精细控制** — 每个 side view 可独立设置 size、insets、alignment
3. **组合优于继承** — 布局集中在 `layoutSubviews`，不受 UITextField 系统行为影响

---

## 一、基础使用

### 最简单的输入框

```swift
let input = HTextFieldView()
input.frame = CGRect(x: 16, y: 100, width: 300, height: 44)
addSubview(input)
```

### 链式配置

```swift
let input = HTextFieldView().config { c in
    c.placeholder("请输入内容")
    c.font(.systemFont(ofSize: 15))
    c.keyboard(.default)
    c.maxLength(20)
}
```

### 回调 — 属性赋值


```swift
let input = HTextFieldView().config { c in
    c.placeholder("请输入手机号")
    c.keyboard(.numberPad).maxLength(11)
    c.leftIcon(UIImage(named: "phone"))
}

// 回调在外单独赋值
input.onTextChange = { text in
    print("实时输入: \(text)")
}
input.onDidEndEditing = { text in
    validateAndSubmit(text)
}
input.onShouldBeginEditing = { [weak self] in
    return self?.isLoggedIn ?? false
}
```

---

## 二、侧边视图 — size、insets、alignment

每个侧边视图通过 `HSideViewConfig` 精细控制，用链式闭包配置：

```swift
c.leftIcon(image) { v in
    v.size(20, 20)              // 固定宽高
    .insets(left: 12, right: 8) // 外边距
    .align(.center)             // 垂直对齐
}
```

### size

| 属性 | 说明 |
|------|------|
| `width` | 视图宽度。设 0 自动取 intrinsicContentSize |
| `height` | 视图高度。设 0 自动撑满容器高度（减去 insets） |

### insets（外边距）

| 参数 | 含义 | 示例 |
|------|------|------|
| `left` | 视图左侧外边距 | `.insets(left: 12)` → 视图距左侧 12pt |
| `right` | 视图右侧外边距（相邻视图或文本的间距） | `.insets(right: 8)` → 视图与文本间距 8pt |
| `top` | 视图顶部偏移 | `.insets(top: 4)` → 视图往下偏移 4pt |
| `bottom` | 视图底部偏移 | `.insets(bottom: 4)` → 视图往上偏移 4pt |

```swift
.insets(8)                                     // 统一
.insets(left: 12, right: 8)                    // 水平
.insets(top: 4, bottom: 4)                     // 垂直
.insets(top: 0, left: 12, bottom: 0, right: 8) // 完整
```

### alignment

| 值 | 效果 |
|----|------|
| `.center`（默认） | 垂直居中 |
| `.top` | 顶部对齐 |
| `.bottom` | 底部对齐 |

### 完整示例

```swift
let input = HTextFieldView().config { c in
    c.placeholder("搜索").font(.systemFont(ofSize: 15))
    c.leftIcon(UIImage(named: "search")) { v in
        v.size(20, 20).insets(left: 12, right: 8).align(.center)
    }
    c.rightButton("发送") { v in
        v.width(60).insets(left: 8, right: 12)
    }
}
```

---

## 三、场景示例

### 场景 1：验证码输入（含自动填充）

```swift
let input = HTextFieldView().config { c in
    c.placeholder("请输入验证码")
    c.keyboard(.numberPad).maxLength(6)
    c.leftIcon(UIImage(named: "sms")) { v in
        v.size(20, 20).insets(left: 12, right: 8)
    }
    c.rightCountdown { v in
        v.width(90).insets(left: 8, right: 12)
    }
    c.autoFillOTP()
}

// 回调在外赋值
input.onOTPFilled = { code in
    print("验证码已自动填入: \(code)")
    verifyCode(code)
}

// countdown handler 也在外赋值
if let btn = input.rightView as? HCountDownButton {
    btn.countDownButtonHandler { sender, _ in
        sender.startCountDownWithSecond(60)
    }
}
```

### 场景 2：搜索框

```swift
let input = HTextFieldView().config { c in
    c.placeholder("搜索")
    c.font(.systemFont(ofSize: 15))
    c.leftIcon(UIImage(named: "search")) { v in
        v.size(20, 20).insets(left: 12, right: 8)
    }
    c.rightButton("清除") { v in
        v.width(50)
    }
}
input.becomeFirstResponder()

input.onTextChange = { text in
    print("搜索: \(text)")
}
```

### 场景 3：金额输入 — 左侧 "$" 前缀 + 右侧单位后缀

```swift
let input = HTextFieldView().config { c in
    c.placeholder("0.00")
    c.keyboard(.decimalPad)
    c.font(.systemFont(ofSize: 20, weight: .medium))
    c.textAlignment(.center)
    c.leftLabel("$") { v in
        v.align(.bottom).insets(bottom: 4)
    }
    c.rightLabel("元") { v in
        v.align(.bottom).insets(bottom: 4)
    }
}
```

### 场景 4：表单—左侧固定宽度标签 + 右侧清除按钮

```swift
let input = HTextFieldView().config { c in
    c.placeholder("请输入姓名")
    c.leftLabel("姓名") { v in
        v.width(40).insets(left: 12, right: 8).align(.center)
    }
    c.rightIcon(UIImage(named: "clear")) { v in
        v.size(18, 18).insets(right: 12)
    }
}

// 点击清除按钮清空文本
if let clearBtn = input.rightView as? UIImageView {
    clearBtn.isUserInteractionEnabled = true
    clearBtn.addGestureRecognizer(UITapGestureRecognizer { _ in
        input.text = ""
    })
}
```

---

## 四、验证码自动填充

### 机制说明

| iOS 版本 | 效果 | 实现 |
|----------|------|------|
| iOS 12+ | 键盘 QuickType 栏显示验证码建议，用户点击后填入 | `textContentType = .oneTimeCode` |
| iOS 17+ | 系统自动从 iMessage 识别验证码，自动填入 textField | `oneTimeCode` + `shouldChangeCharactersIn` 捕获 |

### 判断 OTP 自动填充

在 `shouldChangeCharactersIn:replacementString:` 中判断：
- `range.location == 0` 且 `range.length == 当前内容长度`
- `replacementString.count > 1`（一次性填入完整验证码）

满足以上条件即为系统 OTP 自动填充，触发 `onOTPFilled` 回调。

### 使用

```swift
c.autoFillOTP()         // 启用 oneTimeCode
c.autoSubmitOTP(true)   // 自动提交模式（可选）
```

- **autoSubmitOTP(false)**：每次 OTP 填入都触发 `onOTPFilled`
- **autoSubmitOTP(true)**：OTP 长度 >= `maxLength` 时才触发，同时自动截断

```swift
let input = HTextFieldView().config { c in
    c.placeholder("请输入验证码")
    c.keyboard(.numberPad).maxLength(6)
    c.leftIcon(UIImage(named: "sms"))
    c.rightCountdown()
    c.autoFillOTP()
}

input.onOTPFilled = { code in
    print("验证码已填入: \(code)")
    verifyCode(code)
}
```

---

## 五、配置项完整参考

### 回调（属性赋）

```swift
input.onTextChange = { text in ... }         // 文本实时变化
input.onReturn = { text in ... }             // 点击 return
input.onDidEndEditing = { text in ... }      // 结束编辑
input.onShouldBeginEditing = { return true } // 开始编辑前
input.onOTPFilled = { code in ... }          // 验证码自动填空
```

### 验证码配置（在 config 闭包中）

```swift
c.autoFillOTP()                  // 启用 oneTimeCode 自动填充
c.autoSubmitOTP(true)            // 达 maxLength 自动触发 onOTPFilled（需配 maxLength）
```

### 基础

```swift
c.font(.systemFont(ofSize: 15))
c.textColor(.black)
c.alignment(.natural)
c.placeholder("请输入")
c.placeholderColor(.lightGray)
c.placeholderFont(.systemFont(ofSize: 14))
```

### 输入限制

```swift
c.maxLength(20)          // 最大字符数，0 不限
c.forbidPaste(true)      // 禁止粘贴
c.forbidWhitespace(true) // 禁止空格和换行
c.editable(true)         // 是否可编辑
```

### 键盘

```swift
c.keyboard(.numberPad)
c.returnKey(.done)
c.secure(false)
```

### 容器边距

```swift
c.contentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
c.contentInsets(top: 0, left: 12, bottom: 0, right: 12)  // 便捷
```

### 侧边视图工厂方法

| 方法 | 位置 | 默认宽 | 说明 |
|------|------|--------|------|
| `leftLabel(text:)` | 左 | auto | 文字标签 |
| `leftIcon(image:)` | 左 | 24 | 图标 |
| `leftButton(title:)` | 左 | 60 | 可点击按钮 |
| `leftWebImage()` | 左 | 24 | HWebImageView |
| `leftWebButton(title:)` | 左 | 60 | HWebButtonView |
| `leftView(view:)` | 左 | auto | 自定义视图 |
| `rightLabel(text:)` | 右 | auto | 文字标签 |
| `rightIcon(image:)` | 右 | 24 | 图标 |
| `rightButton(title:)` | 右 | 60 | 可点击按钮 |
| `rightCountdown()` | 右 | 90 | 倒计时按钮 |
| `rightWebImage()` | 右 | 24 | HWebImageView |
| `rightWebButton(title:)` | 右 | 60 | HWebButtonView |
| `rightVerifyCode(width:)` | 右 | 100 | 验证码视图 |
| `rightView(view:)` | 右 | auto | 自定义视图 |

### HSideViewConfig 链式方法

```swift
v.size(width, height)                     // 固定宽高
v.insets(value)                           // 统一外边距
v.insets(top:left:bottom:right:)          // 精细外边距
v.insets(UIEdgeInsets)                    // UIEdgeInsets 设置
v.align(.center)                          // 垂直对齐
v.interactive(true)                       // 可交互
```

---

## 六、获取侧边视图（后续配置）

配置闭包只做初始布局。配置完成后需要操作某视图（如设置 countdown handler），通过以下方式：

### 方式 1：通过 `rightView` / `leftView`（获取该侧第一个视图）

```swift
let input = HTextFieldView().config { c in
    c.rightCountdown()
}

// 直接通过 rightView 获取
if let btn = input.rightView as? HCountDownButton {
    btn.countDownButtonHandler { sender, _ in
        sender.startCountDownWithSecond(60)
    }
}
```

### 方式 2：通过 `sideView(at:side:)` 按 index 获取

```swift
if let btn = input.sideView(at: 0, side: .right) as? HCountDownButton {
    btn.countDownButtonHandler { ... }
}
```

### 方式 3：先创建再传入 config

```swift
let countdown = HCountDownButton()
countdown.countDownButtonHandler { sender, _ in
    sender.startCountDownWithSecond(60)
}

let input = HTextFieldView().config { c in
    c.rightView(countdown) { v in
        v.width(90).insets(left: 8, right: 12)
    }
}
```

---

## 七、与 HTextField（继承版）对比

| 对比项 | HTextField | HTextFieldView |
|--------|-----------|----------------|
| 模式 | 继承 UITextField | 组合（UIView + UITextField） |
| 配置 | 属性赋值或 lazy var | 链式 `config { }` |
| 回调 | 属性赋值 | 属性赋值（不在 config 中） |
| 侧边视图数量 | 每侧 1 个 | 每侧不限 |
| 侧边视图布局 | 系统 leftViewRect 等 | `HSideViewConfig` 独立控制 |
| 文本获取 | `tf.text` | `view.text` |
| 受系统影响 | 需补偿 10pt 内边距 | 不受影响 |
| OTP 自动填充 | 需自行设置 | `autoFillOTP()` 一键开启 |

---

## 八、注意事项

1. **交互式视图**：按钮等需要触摸的，在 config 里设 `interactive(true)` 或使用已预置的工厂方法（countdown、button 已自动设为 interactive）。
2. **回调不在 config 闭包中**：`onTextChange`/`onReturn`/`onDidEndEditing`/`onShouldBeginEditing`/`onOTPFilled` 是属性，在 config 之后单独赋值。
3. **性能**：布局算法 O(n)，n 通常为 1-3，无性能问题。
4. **UITextField 原生操作**：通过 `input.textField` 访问 `attributedText`、`inputView`、`inputAccessoryView` 等。
