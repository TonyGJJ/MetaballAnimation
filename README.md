# FluidBubbleView 实现原理解析

## 1. 核心属性说明
```swift
// 基础绘图层
private let shapeLayer = CAShapeLayer()      // 用于绘制形状
private let gradientLayer = CAGradientLayer() // 用于绘制渐变效果
private var displayLink: CADisplayLink?       // 用于驱动动画
private var startTime: CFTimeInterval = 0     // 记录动画开始时间

// 形状参数
private let baseRadius: CGFloat = 100        // 基础圆形半径
private let numberOfPoints = 120             // 圆形边缘的采样点数量

// 动画参数
private var phase: CGFloat = 0               // 主波动相位
private var secondaryPhase: CGFloat = 0      // 次波动相位
private let waveAmplitude: CGFloat = 5       // 主波动幅度
private let secondaryAmplitude: CGFloat = 3   // 次波动幅度
private let animationSpeed: CGFloat = 1.5     // 动画速度
```

## 2. 初始化和设置
```swift
private func setupView() {
    // 设置渐变层
    gradientLayer.colors = [
        UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 0.8).cgColor,
        UIColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 0.8).cgColor
    ]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    layer.addSublayer(gradientLayer)
    
    // 设置形状层
    shapeLayer.fillColor = UIColor.black.cgColor
    gradientLayer.mask = shapeLayer  // 使用形状层作为渐变层的遮罩
    
    startAnimation()
}
```

## 3. 动画实现
```swift
private func startAnimation() {
    startTime = CACurrentMediaTime()
    // 创建 DisplayLink 以驱动动画，每帧都会调用 updateAnimation
    displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
    displayLink?.add(to: .main, forMode: .common)
}

@objc private func updateAnimation() {
    // 持续更新两个相位值，创造连续的波动效果
    let direction: CGFloat = isClockwise ? 1 : -1
    phase += 0.02 * animationSpeed * direction
    secondaryPhase += 0.026 * animationSpeed * direction
    updatePath()
}
```

## 4. 路径生成（核心算法）
```swift
private func updatePath() {
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let path = UIBezierPath()
    
    // 遍历所有采样点
    for i in 0...numberOfPoints {
        let angle = (CGFloat(i) / CGFloat(numberOfPoints)) * .pi * 2
        
        // 计算波动效果
        let primaryWave = sin(angle * 2 + phase) * waveAmplitude
        let secondaryWave = sin(angle * 3 + secondaryPhase) * secondaryAmplitude
        let wobble = primaryWave + secondaryWave
        
        // 计算最终半径
        let radius = baseRadius + wobble
        
        // 计算点的位置
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        // 绘制路径
        if i == 0 {
            path.move(to: CGPoint(x: x, y: y))
        } else {
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
    
    path.close()
    shapeLayer.path = path.cgPath
}
```

## 实现原理解析

### 1. 基础形状
- 以圆形为基础，通过 baseRadius 定义基础半径
- 将圆周分成 120 个点（numberOfPoints）

### 2. 波动效果
- 使用两个正弦波叠加创造自然的波动
- 主波动：`sin(angle * 2 + phase) * waveAmplitude`
- 次波动：`sin(angle * 3 + secondaryPhase) * secondaryAmplitude`
- 两个波动频率不同（2和3），造成不规则变化

### 3. 动画原理
- 使用 CADisplayLink 在每一帧更新形状
- 通过持续改变 phase 和 secondaryPhase 创造连续运动
- 两个相位速度略有不同（0.02和0.026），产生有机的变化感

### 4. 视觉效果
- 使用 CAGradientLayer 创建渐变效果
- 使用 CAShapeLayer 作为遮罩，结合渐变创造立体感

### 5. 数学原理
- 极坐标系统：使用角度（angle）和半径（radius）定位点
- 正弦波叠加：通过叠加不同频率的正弦波创造复杂变化
- 坐标转换：将极坐标转换为笛卡尔坐标系（x, y）

这种效果本质上是通过对圆形轮廓进行周期性的扰动来模拟流体运动，通过精心选择的参数和多个波动的叠加，创造出自然流畅的效果。

