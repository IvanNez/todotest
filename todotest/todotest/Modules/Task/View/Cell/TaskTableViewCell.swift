//
//  TaskTableViewCell.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    
    var checkAction: ((Task?) -> Void)?
    var currentTask: Task?
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector (checkButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = AppColors.searchTintColor
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        currentTask = task
        titleLabel.attributedText = nil
        titleLabel.text = task.title

        descriptionLabel.text = task.description
        dateLabel.text = DateFormatter.localizedString(from: task.date, dateStyle: .short, timeStyle: .none)
        if task.isCompleted {
            checkButton.setImage(UIImage(resource: .select), for: .normal)
            titleLabel.textColor = AppColors.searchTintColor
            descriptionLabel.textColor = AppColors.searchTintColor
            let attributedString = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: AppColors.searchTintColor
                ]
            )
            titleLabel.attributedText = attributedString
        } else {
            checkButton.setImage(UIImage(resource: .notSelect), for: .normal)
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
        }
    }
    
    private func setup() {
        
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkButton.heightAnchor.constraint(equalToConstant: 24),
            checkButton.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor,constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
           
            descriptionLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkAction?(currentTask)
    }
}
