//
//  ViewController.swift
//  MemoryLeak
//
//  Created by Akirah Dev on 12/03/22.
//  
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button1 = UIButton()
        button1.setTitle("Weak Reference Here", for: .normal)
        button1.addTarget(self, action: #selector(didTapWeakRef), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.setTitle("Unowned Reference Here", for: .normal)
        button2.addTarget(self, action: #selector(didTapUnownedRef), for: .touchUpInside)
        
        let stackView = UIStackView(frame: .init(x: 0, y: 0, width: 256, height: 50))
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.center = view.center
        
        view.addSubview(stackView)
    }

    @objc private func didTapWeakRef() {
        let vc = TheWeakVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapUnownedRef() {
        let vc = TheUnownedVC()
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - The Weak Samples
final class TheWeakView: UIView {
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

final class TheWeakVC: UIViewController {
    
    lazy var weakView: TheWeakView = {
        TheWeakView(vc: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(weakView)
    }
}

// MARK: - The Unowned Samples
final class TheUnownedVC: UIViewController {
    
    var john: Customer?
    
    deinit { print("\(String(describing: self)) is being deinitialized") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let label = UILabel(frame: .init(x: 0, y: 0, width: 256, height: 50))
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Swipe down and see log"
        label.textColor = .yellow
        label.textAlignment = .center
        label.center = view.center
        view.addSubview(label)
        
        // Initiate
        john = Customer(name: "John Appleseed")
        john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
    }
}

// MARK: - Unowned Non-Optional
final class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

final class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
