//
//  DescriptionViewProtocol.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import UIKit

protocol DescriptionViewProtocol: AnyObject {
    func updateTaskDetails(title: String, date: String, description: String)
}

class DescriptionViewController: UIViewController{
    var presenter: DescriptionPresenterProtocol!
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.delegate = self
        textField.inputAccessoryView = HelperFunc.createToolbar(target: self, action: #selector(endEditingTapped))
        textField.font = UIFont.systemFont(ofSize: 34)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 28)
            ]
        )
        return textField
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = HelperFunc.convertToString(Date())
        return label
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Введите описание"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.delegate = self
        textView.inputAccessoryView = HelperFunc.createToolbar(target: self, action: #selector(endEditingTapped))
        textView.backgroundColor = .clear
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.backToView(title: titleTextField.text, description: descriptionTextView.text)
    }
}

// Setup UI
private extension DescriptionViewController {
    func setup() {
        setupUI()
        setupNavBar()
        presenter.loadTask()
    }
    func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(hex: "#FED702")
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor, constant: 6),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    func setupPlaceholder() {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Введите описание"
            descriptionTextView.textColor = .gray
            descriptionTextView.font = UIFont.systemFont(ofSize: 14)
        }
    }
}

// OBJC
private extension DescriptionViewController {
    @objc func  endEditingTapped() {
        view.endEditing(true)
    }
}

// UITextViewDelegate
extension DescriptionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Введите описание" {
            textView.text = ""
            textView.textColor = .white
            textView.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
}

// UITextFieldDelegate
extension DescriptionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension DescriptionViewController: DescriptionViewProtocol {
    func updateTaskDetails(title: String, date: String, description: String) {
        titleTextField.text = title
        dateLabel.text = date
        if description != "" {
            descriptionTextView.text = description
            descriptionTextView.textColor = .white
        }
    }
}
