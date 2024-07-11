//===----------------------------------------------------------*- Swift -*-===//
//
// Created by DouKing on 2024/3/19.
// Copyright © 2024 DouKing. All rights reserved.
//
//===----------------------------------------------------------------------===//

import UIKit
import Combine
import Example

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    let tap1 = PassthroughSubject<String, Never>()
    let tap2 = PassthroughSubject<Int, Never>()
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        let alpha: CGFloat = CGFloat((self.navigationController?.viewControllers.count ?? 1)) / 2
        
        let appearance = navigationItem.standardAppearance ?? UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(white: 0, alpha: alpha)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        let text = try! AttributedString(markdown:"""
        **Thank you!** Please visit our [website](https://example.com)
        """)
        let attributedStr = NSMutableAttributedString(text)
        attributedStr.addAttribute(.font, 
                                   value: UIFont.preferredFont(forTextStyle: .title2),
                                   range: NSRange(location: 0, length: attributedStr.length))
        self.titleLabel.attributedText = attributedStr
        
        do {
            let btn = UIButton(type: .custom)
            btn.setTitle("▷", for: .normal)
            btn.tintColor = .white
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
            btn.frame = CGRect(origin: .init(x: 10, y: 100), size: .init(width: 60, height: 60))
            btn.backgroundColor = .red
            btn.layer.cornerRadius = 30
            btn.addTarget(self, action: #selector(handleTap1), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        
        do {
            let btn = UIButton(type: .custom)
            btn.tintColor = UIColor.white
            btn.setImage(UIImage(systemName: "play")?.applyingSymbolConfiguration(.init(pointSize: 30, weight: .bold)), for: .normal)
            btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            btn.frame = CGRect(origin: .init(x: 120, y: 100), size: .init(width: 60, height: 60))
            btn.backgroundColor = .red
            btn.layer.cornerRadius = 30
            btn.addTarget(self, action: #selector(handleTap2), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        
        do {
            let bar = UIView(frame: CGRect(x: 30, y: 200, width: 260, height: 60))
            bar.backgroundColor = UIColor.red
            self.view.addSubview(bar)
            
            bar.layer.shadowColor = UIColor.lightGray.cgColor
            bar.layer.shadowOpacity = 1
            bar.layer.shadowRadius = 20
            bar.layer.shadowOffset = CGSize(width: 0, height: -10)
        }
        
        do {
            let imgView = UIImageView(frame: CGRect(x: 20, y: 300, width: 300, height: 300))
            
            self.view.addSubview(imgView)
        }
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        tap1.combineLatest(tap2)
            .sink { (v1, v2) in
                print(v1, v2)
            }
            .store(in: &self.bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func handleTap1() {
        tap1.send("\(Date())")
    }
    
    @objc
    func handleTap2() {
        tap2.send(1)
    }
}
