//
//  ViewController.swift
//  MemoryLeak
//
//  Created by Akirah Dev on 12/03/22.
//  
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: .init(x: 0, y: 0, width: 100, height: 50))
        button.setTitle("Tap Me", for: .normal)
        button.center = view.center
        button.addTarget(self, action: #selector(didTapMe), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func didTapMe() {
        let vc = TheWeakVC()
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - The Weak Samples
class TheWeakView: UIView {
    weak var vc: TheWeakVC?
    
    init(vc: TheWeakVC?) {
        self.vc = vc
        super.init(frame: .init(x: 0, y: 0, width: 100, height: 100))
        backgroundColor = .yellow
        center = vc?.view.center ?? .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TheWeakVC: UIViewController {
    
    lazy var weakView: TheWeakView = {
        TheWeakView(vc: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(weakView)
    }
}

