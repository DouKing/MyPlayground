//===----------------------------------------------------------*- Swift -*-===//
//
// Created by wuyikai on 2024/6/12.
// Copyright © 2024 wuyikai. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit

class OtherViewController: UIViewController {
    
    var topImageView: UIImageView?
    var bottomImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(resource: .bdMainTextImg1))
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        
        let imageView2 = UIImageView(image: UIImage(resource: .bdMainSketchImg1))
        imageView2.backgroundColor = .black
        imageView2.contentMode = .scaleAspectFill
        
        imageView.frame = self.view.bounds
        imageView2.frame = self.view.bounds
        
        self.view.addSubview(imageView)
        self.view.addSubview(imageView2)
        
        self.topImageView = imageView2
        self.bottomImageView = imageView
    }
    
    var index = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            index = (index + 1) % 5
        }
        
        let imageName = "我在精神病院学斩神_林七夜_\(index)"
        self.bottomImageView?.image = UIImage(named: imageName)
        self.topImageView?.alpha = 1
        
        let maskView = UIView(frame: self.topImageView!.bounds)
        let hCount = 15
        let vCount = 20
        let fadeWidth = maskView.frame.width / CGFloat(hCount)
        let fadeHeight = maskView.frame.height / CGFloat(vCount)
        
        for line in 0..<hCount {
            for row in 0..<vCount {
                let frame = CGRect(x: CGFloat(line) * fadeWidth, y: CGFloat(row) * fadeHeight, width: fadeWidth, height: fadeHeight)
                let fadeView = UIView(frame: frame)
                fadeView.tag = line * vCount + row + 10000
                fadeView.backgroundColor = .red
                maskView.addSubview(fadeView)
            }
        }
        self.topImageView!.mask = maskView
        
        for line in 0..<hCount {
            for row in 0..<vCount {
                let idx = line * vCount + row
                let fadeView = maskView.viewWithTag(idx + 10000)
                UIView.animate(withDuration: 0.15, delay: TimeInterval(0.02 * CGFloat(line))) {
                    fadeView!.alpha = 0
                } completion: { _ in
                    if idx == hCount * vCount - 1 {
                        self.view.sendSubviewToBack(self.topImageView!)
                        self.topImageView?.mask = nil
                        (self.topImageView, self.bottomImageView) = (self.bottomImageView, self.topImageView)
                    }
                }
            }
        }
        
//        UIView.animate(withDuration: 0.85, delay: 0, options: .curveEaseInOut) {
//            self.topImageView?.alpha = 0
//            self.bottomImageView?.alpha = 1
//        } completion: { _ in
//            self.view.sendSubviewToBack(self.topImageView!)
//            (self.topImageView, self.bottomImageView) = (self.bottomImageView, self.topImageView)
//        }
    }
}

extension OtherViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.view.sendSubviewToBack(self.topImageView!)
        self.topImageView?.transform = .identity
        (self.topImageView, self.bottomImageView) = (self.bottomImageView, self.topImageView)
    }
}
