//
//  ViewController.swift
//  TestAn
//
//  Created by shanhs on 2025/1/6.
//

import UIKit

class ViewController: UIViewController {
    
    private var fluidBubble: FluidBubbleView!
    private var directionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFluidBubble()
        setupDirectionButton()
    }
    
    private func setupFluidBubble() {
        fluidBubble = FluidBubbleView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        fluidBubble.center = view.center
        view.addSubview(fluidBubble)
    }
    
    private func setupDirectionButton() {
        directionButton = UIButton(type: .system)
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionButton.setTitle("切换方向", for: .normal)
        directionButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        directionButton.layer.cornerRadius = 10
        directionButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
        
        view.addSubview(directionButton)
        
        // 设置按钮约束
        NSLayoutConstraint.activate([
            directionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            directionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
        
        // 更新按钮标题
        updateButtonTitle()
    }
    
    @objc private func directionButtonTapped() {
        fluidBubble.toggleDirection()
        updateButtonTitle()
    }
    
    private func updateButtonTitle() {
        let directionText = fluidBubble.isClockwise ? "逆时针" : "顺时针"
        directionButton.setTitle("当前方向: \(directionText)", for: .normal)
    }
}

