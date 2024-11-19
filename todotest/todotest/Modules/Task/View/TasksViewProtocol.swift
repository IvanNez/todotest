//
//  TasksViewProtocol.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


//
//  TasksViewProtocol.swift
//  todo
//
//  Created by Иван Незговоров on 16.11.2024.
//




import UIKit

protocol TasksViewProtocol: AnyObject {
    func reloadTableView()
}

final class TasksViewController: UIViewController {
    var presenter: TasksPresenterProtocol!
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.delegate = self
        sb.searchBarStyle = .minimal
        sb.backgroundColor = .clear
        sb.delegate = self
        sb.searchTextField.delegate = self
        sb.searchTextField.inputAccessoryView = HelperFunc.createToolbar(target: self, action: #selector(endEditingTapped))
        if let textField = sb.value(forKey: "searchField") as? UITextField,
           let iconView = textField.leftView as? UIImageView {
            iconView.tintColor = AppColors.searchTintColor
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        }
        if let textField = sb.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: AppColors.searchTintColor]
            )
            
            textField.backgroundColor = AppColors.searchBackColor
            textField.textColor = .white
        }
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        tb.separatorColor = AppColors.separatorTableView
        tb.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tb.backgroundColor = .clear
        tb.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.searchBackColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var countLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        return lbl
    }()
    private lazy var newTaskButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor(hex: "#FED702")
        button.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.newLoad()
        navigationController?.navigationBar.isHidden = true
    }
}

// Setup UI
private extension TasksViewController {
    func setup() {
        setupUI()
    }
    func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(countLabel)
        bottomView.addSubview(newTaskButton)
        
        // МОЖНО БЫЛО ИСПОЛЬЗОВАТЬ VSTACK
        // Я ИСПОЛЬЗОВАЛ КАЖДЫЙ КОМПОНЕНТ ОТДЕЛЬНО
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 83),
            
            countLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20.5),
            
            newTaskButton.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            newTaskButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            newTaskButton.heightAnchor.constraint(equalToConstant: 28),
            newTaskButton.widthAnchor.constraint(equalToConstant: 68),
            
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    func createView(task: Task) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.tag = 100
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDetailsView))
        blurView.addGestureRecognizer(tapGesture)
        
        let taskDetailsView = createTaskDetailsView(with: task)
        taskDetailsView.translatesAutoresizingMaskIntoConstraints = false
        taskDetailsView.tag = 200
        view.addSubview(taskDetailsView)
        
        
        NSLayoutConstraint.activate([
            taskDetailsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskDetailsView.heightAnchor.constraint(equalToConstant: 106)
        ])
        
        let customMenu = CustomMenu()
        customMenu.tag = 400
        customMenu.actionHandler = { [weak self] action in
            guard let self else { return }
            handleMenuAction(action)
        }
        view.addSubview(customMenu)
        
        NSLayoutConstraint.activate([
            customMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customMenu.topAnchor.constraint(equalTo: taskDetailsView.bottomAnchor, constant: 16),
            customMenu.widthAnchor.constraint(equalToConstant: 254)
        ])
        customMenu.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        taskDetailsView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        blurView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            blurView.alpha = 1
            taskDetailsView.transform = .identity
            customMenu.transform = .identity
        }
    }
    func createTaskDetailsView(with task: Task) -> UIView {
        let detailsView = UIView()
        detailsView.backgroundColor = AppColors.searchBackColor
        detailsView.layer.cornerRadius = 12
        detailsView.layer.masksToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = task.title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = task.description
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsView.addSubview(descriptionLabel)
        
        let dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = DateFormatter.localizedString(from: task.date, dateStyle: .short, timeStyle: .none)
        detailsView.addSubview(dateLabel)
        
        var descriptionConstraint: NSLayoutConstraint
        if titleLabel.text == "" {
            descriptionConstraint = descriptionLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 40)
        } else {
            descriptionConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            
            descriptionConstraint,
            descriptionLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
        ])
        
        return detailsView
    }
}

// Func for logic
private extension TasksViewController {
    func handleMenuAction(_ action: String) {
        switch action {
        case "Редактировать":
            presenter.newView(type: .edit,  view: self)
            dismissDetailsView()
        case "Поделиться":
            shareTask()
        case "Удалить":
            presenter.deleteSelectedTask()
            dismissDetailsView()
        default:
            break
        }
    }
    func shareTask() {
        if let task = presenter.selectedTask {
            let taskDetails = "\(task.title)\n\(task.description)" // Format your task data as needed
            let activityController = UIActivityViewController(activityItems: [taskDetails], applicationActivities: nil)
            
            // Exclude unnecessary activities (optional)
            activityController.excludedActivityTypes = [.addToReadingList, .assignToContact]
            
            // Present the activity view controller
            present(activityController, animated: true, completion: nil)
        } else {
            print("No task selected to share")
        }
    }
}

// OBJC
private extension TasksViewController {
    @objc func dismissDetailsView() {
        if let menuView = view.viewWithTag(400) {
            UIView.animate(withDuration: 0.3, animations: {
                menuView.alpha = 0
            }) { _ in
                menuView.removeFromSuperview()
            }
        }
        if let blurView = view.viewWithTag(100) {
            UIView.animate(withDuration: 0.3, animations: {
                blurView.alpha = 0
            }) { _ in
                blurView.removeFromSuperview()
            }
        }
        
        if let detailsView = view.subviews.first(where: { $0.tag == 200 }) {
            UIView.animate(withDuration: 0.3, animations: {
                detailsView.alpha = 0
            }) { _ in
                detailsView.removeFromSuperview()
            }
        }
    }
    @objc func newTaskButtonTapped() {
        presenter.newView(type: .new, view: self)
    }
    @objc func endEditingTapped() {
        view.endEditing(true)
    }
}

// UISearchBarDelegate
extension TasksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchTasks(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.endEditing(true)
    }
}

extension TasksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

// UITableViewDataSource & UITableViewDelegate
extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tasksCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        let task =  presenter.task(at: indexPath.row)
        cell.configure(with: task)
        cell.selectionStyle = .none
        cell.checkAction = { [weak self] task in
            guard let self else { return }
            presenter.toggleTaskCompletion(at: task!)
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = presenter.task(at: indexPath.row)
        presenter.selectedTask = presenter.task(at: indexPath.row)
        createView(task: task)
    }
}


extension TasksViewController: TasksViewProtocol {
    func reloadTableView() {
        countLabel.text = "\(presenter.tasksCount) Задач"
        tableView.reloadData()
    }
}
