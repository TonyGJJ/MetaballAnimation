# MetaballAnimation
完成一个元球的流动效果

实现原理解析：
基础形状：
以圆形为基础，通过 baseRadius 定义基础半径
将圆周分成 120 个点（numberOfPoints）
波动效果：
使用两个正弦波叠加创造自然的波动
主波动：sin(angle * 2 + phase) * waveAmplitude
次波动：sin(angle * 3 + secondaryPhase) * secondaryAmplitude
两个波动频率不同（2和3），造成不规则变化
动画原理：
使用 CADisplayLink 在每一帧更新形状
通过持续改变 phase 和 secondaryPhase 创造连续运动
两个相位速度略有不同（0.02和0.026），产生有机的变化感
视觉效果：
使用 CAGradientLayer 创建渐变效果
使用 CAShapeLayer 作为遮罩，结合渐变创造立体感
数学原理：
极坐标系统：使用角度（angle）和半径（radius）定位点
正弦波叠加：通过叠加不同频率的正弦波创造复杂变化
坐标转换：将极坐标转换为笛卡尔坐标系（x, y）
