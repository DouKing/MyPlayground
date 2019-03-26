//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

extension UIView {
    public convenience init(useAutoLayout: Bool = true) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = !useAutoLayout
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//: ## 1. NSLayoutAnchor 布局锚点

        let containerView = UIView(useAutoLayout: true)
        containerView.backgroundColor = .lightGray
        view.addSubview(containerView)

        do {
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }

/*:
## 2. UILayoutGuide 布局参照

> 依赖 NSLayoutAnchor 实现
*/

        do {
            // A B C 三个视图等宽切间距相等
            let viewA = UIView(useAutoLayout: true)
            viewA.backgroundColor = .red
            view.addSubview(viewA)

            let viewB = UIView(useAutoLayout: true)
            viewB.backgroundColor = .yellow
            view.addSubview(viewB)

            let viewC = UIView(useAutoLayout: true)
            viewC.backgroundColor = .blue
            view.addSubview(viewC)

            let spaceAB = UILayoutGuide()
            containerView.addLayoutGuide(spaceAB) //将 layoutGuide 添加进 view，其坐标以 view 为参考系
            let spaceBC = UILayoutGuide()
            containerView.addLayoutGuide(spaceBC)

            viewA.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            viewC.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true

            viewA.widthAnchor.constraint(equalTo: viewB.widthAnchor).isActive = true
            viewB.widthAnchor.constraint(equalTo: viewC.widthAnchor).isActive = true

            viewA.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            viewA.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            viewB.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            viewB.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            viewC.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            viewC.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

            spaceAB.widthAnchor.constraint(equalTo: spaceBC.widthAnchor).isActive = true
            spaceAB.widthAnchor.constraint(equalToConstant: 10).isActive = true
            spaceAB.leadingAnchor.constraint(equalTo: viewA.trailingAnchor).isActive = true
            spaceAB.trailingAnchor.constraint(equalTo: viewB.leadingAnchor).isActive = true
            spaceBC.leadingAnchor.constraint(equalTo: viewB.trailingAnchor).isActive = true
            spaceBC.trailingAnchor.constraint(equalTo: viewC.leadingAnchor).isActive = true
        }

//: 它是一个矩形区域。可用来封装视图模块
        do {
            // 将 label 和 textField 封装到一个矩形区域

            let container = UILayoutGuide()
            view.addLayoutGuide(container)

            let label = UILabel(useAutoLayout: true)
            label.text = "user name"
            view.addSubview(label)

            let textField = UITextField(useAutoLayout: true)
            textField.borderStyle = .roundedRect
            textField.placeholder = "please input your user name"
            view.addSubview(textField)

            label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            textField.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            textField.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5).isActive = true

            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            container.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive = true
            container.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }

/*:
## 3. UILayoutSupport

这是一个协议。UIViewController 的属性 `topLayoutGuide` 和 `bottomLayoutGuide` 实现了该协议。

`topLayoutGuide` 定义了头部 bar 的层级，`bottomLayoutGuide` 定义了底部 bar 的层级。可以利用这两个属性，将视图显示区域限定在上下 bar 之间
*/

}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
