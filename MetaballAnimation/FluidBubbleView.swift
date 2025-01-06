import UIKit

class FluidBubbleView: UIView {
    
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
    
    // 添加方向控制参数
    public var isClockwise: Bool = false {
        didSet {
            // 当方向改变时，可以添加一些过渡效果
            updatePath()
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
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
        gradientLayer.mask = shapeLayer
        
        startAnimation()
    }
    
    private func startAnimation() {
        startTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateAnimation() {
        let direction: CGFloat = isClockwise ? 1 : -1
        phase += 0.02 * animationSpeed * direction
        secondaryPhase += 0.026 * animationSpeed * direction
        updatePath()
    }
    
    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath()
        
        // 绘制带有双重波动的圆形
        for i in 0...numberOfPoints {
            let angle = (CGFloat(i) / CGFloat(numberOfPoints)) * .pi * 2
            
            // 组合两个不同频率的波动
            let primaryWave = sin(angle * 2 + phase) * waveAmplitude
            let secondaryWave = sin(angle * 3 + secondaryPhase) * secondaryAmplitude
            let wobble = primaryWave + secondaryWave
            
            let radius = baseRadius + wobble
            
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.close()
        shapeLayer.path = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        shapeLayer.frame = bounds
        updatePath()
    }
    
    deinit {
        displayLink?.invalidate()
    }

    // 可选：添加一个切换方向的方法
    public func toggleDirection() {
        isClockwise.toggle()
    }
}
