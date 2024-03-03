//
//  RootViewController.swift
//  AlienClock
//
//  Created by Alwyn Yeo on 3/3/24.
//

import UIKit

final class RootViewController: UIViewController {
    // MARK: - UI Declarations
    private lazy var rootStackView = UIStackView()
    private lazy var alienTimeStackView = UIStackView()
    private lazy var earthTimeStackView = UIStackView()

    private lazy var alienTimeTitleLabel = UILabel()
    private lazy var alienDateTimeLabel = UILabel()

    private lazy var earthTimeTitleLabel = UILabel()
    private lazy var earthDateTimeLabel = UILabel()

    private lazy var earthSetYearTextField = UITextField()
    private lazy var earthSetMonthTextField = UITextField()
    private lazy var earthSetDayTextField = UITextField()
    private lazy var earthSetHourTextField = UITextField()
    private lazy var earthSetMinuteTextField = UITextField()
    private lazy var earthSetSecondTextField = UITextField()

    private lazy var earthSetDateTimeButton = UIButton()

    // MARK: - State
    private var viewModel: RootViewModel?

    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let earthDate = Date(timeIntervalSince1970: .zero)
        viewModel = RootViewModel(view: self)
        setUpUI()
        viewModel?.startTimeConversion(from: earthDate)
    }

    // MARK: - Helper Functions
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain, target: self,
            action: #selector(handleRightBarButtonItem(_ :))
        )

        setUpAlienTimeTitleLabel()
        setUpAlienDateTimeLabel()
        setUpEarthTimeTitleLabel()
        setUpEarthDateTimeLabel()
        setUpEarthSetYearTextField()
        setUpEarthSetMonthTextField()
        setUpEarthSetDayTextField()
        setUpEarthSetHourTextField()
        setUpEarthSetMinuteTextField()
        setUpEarthSetSecondTextField()
        setUpEarthSetDateTimeButton()
        setUpAlienTimeStackView()
        setUpEarthTimeStackView()
        setUpRootStackView()
    }

    @objc private func handleRightBarButtonItem(_ sender: UIBarButtonItem) {
        viewModel?.resetTimer()
    }

    @objc private func handleEarthDateTimeButton(_ sender: UIButton) {
        let newYearString = earthSetYearTextField.text ?? ""
        let newMonthString = earthSetMonthTextField.text ?? ""
        let newDayString = earthSetDayTextField.text ?? ""
        let newHourString = earthSetHourTextField.text ?? ""
        let newMinuteString = earthSetMinuteTextField.text ?? ""
        let newSecondString = earthSetSecondTextField.text ?? ""

        let newDateString = "\(newYearString) \(newMonthString) \(newDayString) \(newHourString) \(newMinuteString) \(newSecondString)"
        viewModel?.handleSetEarthDateTimeButton(newDateString: newDateString)
    }
}

// MARK: - Extension
extension RootViewController: RootViewType {
    func updateAlienDateTimeLabel(dateString: String) {
        alienDateTimeLabel.text = dateString
    }

    func updateEarthDateTimeLabel(dateString: String) {
        earthDateTimeLabel.text = dateString
    }

    func clearTextFields() {
        earthSetYearTextField.text = nil
        earthSetMonthTextField.text = nil
        earthSetDayTextField.text = nil
        earthSetHourTextField.text = nil
        earthSetMinuteTextField.text = nil
        earthSetSecondTextField.text = nil
    }
}

// MARK: - Extension UITextFieldDelegate
extension RootViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length

        // Check for non-numeric characters
        let characterSet = CharacterSet.decimalDigits
        if !string.isEmpty && !string.trimmingCharacters(in: characterSet).isEmpty {
            return false
        }

        let newText = text.appending(string)
        let number = Int(newText) ?? .zero

        if textField == earthSetYearTextField {
            if newLength == 3, let number = Int(text.appending(string)) {
                return number >= 197
            } else {
                return newLength <= 4
            }
        } else if textField == earthSetMonthTextField {
            return number <= 12
        } else if textField == earthSetDayTextField {
            return number <= 31
        } else if textField == earthSetHourTextField {
            return number <= 24
        } else if textField == earthSetMinuteTextField {
            return number <= 60
        } else {
            return number <= 60
        }
    }
}

// MARK: - UI
private extension RootViewController {
    func setUpAlienTimeTitleLabel() {
        alienTimeTitleLabel.text = "Alien Time"
        alienTimeTitleLabel.font = .preferredFont(forTextStyle: .title3)
        alienTimeTitleLabel.textColor = .label
        alienTimeTitleLabel.numberOfLines = .zero
    }

    func setUpAlienDateTimeLabel() {
        alienDateTimeLabel.text = "-"
        alienDateTimeLabel.textColor = .label
        alienDateTimeLabel.numberOfLines = .zero
    }

    func setUpEarthTimeTitleLabel() {
        earthTimeTitleLabel.text = "Earth Time"
        earthTimeTitleLabel.font = .preferredFont(forTextStyle: .title3)
        earthTimeTitleLabel.textColor = .label
        earthTimeTitleLabel.numberOfLines = .zero
    }

    func setUpEarthDateTimeLabel() {
        earthDateTimeLabel.text = "-"
        earthDateTimeLabel.textColor = .label
        earthDateTimeLabel.numberOfLines = .zero
    }

    func setUpEarthSetYearTextField() {
        earthSetYearTextField.placeholder = "Update Earth Year"
        earthSetYearTextField.delegate = self
        earthSetYearTextField.borderStyle = .roundedRect
        earthSetYearTextField.keyboardType = .numberPad
    }

    func setUpEarthSetMonthTextField() {
        earthSetMonthTextField.placeholder = "Update Earth Month"
        earthSetMonthTextField.delegate = self
        earthSetMonthTextField.borderStyle = .roundedRect
        earthSetYearTextField.keyboardType = .numberPad
    }

    func setUpEarthSetDayTextField() {
        earthSetDayTextField.placeholder = "Update Earth Day"
        earthSetDayTextField.delegate = self
        earthSetDayTextField.borderStyle = .roundedRect
        earthSetYearTextField.keyboardType = .numberPad
    }

    func setUpEarthSetHourTextField() {
        earthSetHourTextField.placeholder = "Update Earth Hour"
        earthSetHourTextField.delegate = self
        earthSetHourTextField.borderStyle = .roundedRect
        earthSetYearTextField.keyboardType = .numberPad
    }

    func setUpEarthSetMinuteTextField() {
        earthSetMinuteTextField.placeholder = "Update Earth Minute"
        earthSetMinuteTextField.delegate = self
        earthSetMinuteTextField.borderStyle = .roundedRect
        earthSetYearTextField.keyboardType = .numberPad
    }

    func setUpEarthSetSecondTextField()  {
        earthSetSecondTextField.placeholder = "Update Earth Second"
        earthSetSecondTextField.delegate = self
        earthSetSecondTextField.borderStyle = .roundedRect
        earthSetYearTextField.keyboardType = .numberPad
    }

    func setUpEarthSetDateTimeButton() {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Set Earth Date Time"
        configuration.buttonSize = .mini
        configuration.cornerStyle = .medium
        earthSetDateTimeButton.configuration = configuration
        earthSetDateTimeButton.addTarget(self, action: #selector(handleEarthDateTimeButton), for: .touchUpInside)
    }

    func setUpAlienTimeStackView() {
        alienTimeStackView.axis = .vertical
        alienTimeStackView.spacing = 8

        alienTimeStackView.addArrangedSubview(alienTimeTitleLabel)
        alienTimeStackView.addArrangedSubview(alienDateTimeLabel)
    }

    func setUpEarthTimeStackView() {
        earthTimeStackView.axis = .vertical
        earthTimeStackView.spacing = 8

        earthTimeStackView.addArrangedSubview(earthTimeTitleLabel)
        earthTimeStackView.addArrangedSubview(earthDateTimeLabel)
        earthTimeStackView.addArrangedSubview(earthSetYearTextField)
        earthTimeStackView.addArrangedSubview(earthSetMonthTextField)
        earthTimeStackView.addArrangedSubview(earthSetDayTextField)
        earthTimeStackView.addArrangedSubview(earthSetHourTextField)
        earthTimeStackView.addArrangedSubview(earthSetMinuteTextField)
        earthTimeStackView.addArrangedSubview(earthSetSecondTextField)
        earthTimeStackView.addArrangedSubview(earthSetDateTimeButton)
    }

    func setUpRootStackView() {
        rootStackView.axis = .horizontal
        rootStackView.spacing = 8
        rootStackView.distribution = .fillEqually

        rootStackView.addArrangedSubview(alienTimeStackView)
        rootStackView.addArrangedSubview(earthTimeStackView)

        view.addSubview(rootStackView)

        rootStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            rootStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
