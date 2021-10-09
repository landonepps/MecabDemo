//
//  TokenizerViewController.swift
//  MecabDemo
//
//  Created by Landon Epps on 10/9/21.
//

import UIKit

class TokenizerTableViewController: UIViewController {

    // Tokenizer

    private var tokenizer: Tokenizer?
    private var tokens = [Token]() {
        didSet {
            tableView.reloadData()
        }
    }

    // Header

    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Text to tokenize..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let button: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "Tokenize!"
        let button = UIButton(configuration: buttonConfiguration)
        button.addTarget(self, action: #selector(tokenize), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Table View

    static var reuseIdentifier = "TokenTableViewCell"

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tokenizer = Tokenizer()

        // Set up views
        textField.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        tableView.dataSource = self

        view.backgroundColor = .systemBackground
        topStackView.addArrangedSubview(textField)
        topStackView.addArrangedSubview(button)
        view.addSubview(topStackView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            topStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            topStackView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // Actions

    @objc func tokenize() {
        if let tokenizer = tokenizer, let text = textField.text {
            tokens = tokenizer.parse(text)
            textField.resignFirstResponder()
        }
    }
}

extension TokenizerTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tokenize()
        return false
    }
}

extension TokenizerTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        let token = tokens[indexPath.row]
        var content = cell.defaultContentConfiguration()
        // All tokens have a surface property (the exact substring)
        content.text = token.surface

        var secondaryText = [String]()
        // But the other properties aren't required, so they're optional
        if let reading = token.reading {
            secondaryText.append("読み: \(reading)")
        }

        if let originalForm = token.originalForm {
            secondaryText.append("原形: \(originalForm)")
        }

        if let inflection = token.inflection {
            secondaryText.append("活用形: \(inflection)")
        }

        // If there are no parts of speech, it's an empty array, not nil
        if !token.partsOfSpeech.isEmpty {
            secondaryText.append("品詞: \(token.partsOfSpeech.joined(separator: "、"))")
        }

        content.secondaryText = secondaryText.joined(separator: "\n")

        cell.contentConfiguration = content
        cell.backgroundConfiguration = .listPlainCell()

        return cell
    }
}
