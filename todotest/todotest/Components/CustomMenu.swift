//
//  CustomMenu.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import UIKit

class CustomMenu: UIView {
    
    var actionHandler: ((String) -> Void)?
    
    private let menuItems: [(title: String, icon: UIImage?)] = [
        ("Редактировать", UIImage(systemName: "pencil")),
        ("Поделиться", UIImage(systemName: "square.and.arrow.up")),
        ("Удалить", UIImage(systemName: "trash"))
    ]
    
    init() {
        super.init(frame: .zero)
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMenu()
    }
    
    private func setupMenu() {
        self.backgroundColor = UIColor(hex: "#EDEDEDCC").withAlphaComponent(0.8)
        self.layer.cornerRadius = 12
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var previousView: UIView? = nil
        
        for (index, item) in menuItems.enumerated() {
            let menuItemView = createMenuItemView(title: item.title, icon: item.icon, index: index)
            menuItemView.translatesAutoresizingMaskIntoConstraints = false
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped(_:)))
            menuItemView.addGestureRecognizer(tapGesture)
            menuItemView.tag = index
            
            self.addSubview(menuItemView)
            
            
            NSLayoutConstraint.activate([
                menuItemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                menuItemView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                menuItemView.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            if let previousView = previousView {
                menuItemView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8).isActive = true
            } else {
                menuItemView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
            }
            
            if index < menuItems.count - 1 {
                let separatorView = createSeparator()
                self.addSubview(separatorView)
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    separatorView.topAnchor.constraint(equalTo: menuItemView.bottomAnchor),
                    separatorView.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
            
            previousView = menuItemView
        }
        
        self.bottomAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: "#4D555E80").withAlphaComponent(0.5)
        return separator
    }
    
    
    private func createMenuItemView(title: String, icon: UIImage?, index: Int) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Create the label for the text
        let titleLabel = UILabel()
        if index == 2 {
            titleLabel.textColor = UIColor(hex: "#D70015")
        } else {
            titleLabel.textColor = UIColor(hex: "#040404")
        }
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the image view for the icon
        let iconImageView = UIImageView(image: icon)
        if index == 2 {
            iconImageView.tintColor = UIColor(hex: "#D70015")
        } else {
            iconImageView.tintColor = UIColor(hex: "#040404")
        }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconImageView)
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return containerView
    }
    
    @objc private func menuItemTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        switch tappedView.tag {
        case 0:
            actionHandler?("Редактировать")
        case 1:
            actionHandler?("Поделиться")
        case 2:
            actionHandler?("Удалить")
        default:
            break
        }
    }
}

