//
//  DatePickerView.swift
//
//  Created by Armen on 24/01/18.
//  Copyright © 2017 Friends. All rights reserved.
//

import UIKit

@objc protocol DataPickerViewDataSource {

    // Called when a row is clicked. The view will be automatically dismissed after this call returns
    @objc optional func didSelectRow(row: Int);

    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button

    @objc optional func willPresentDataPickerView(dataPicker: DatePickerView, selectedRow: Int); // before animation and showing view
    @objc optional func didPresentDataPickerView(selectedRow: Int); // // after animation

    @objc optional func willDismissDataPickerView();
    @objc optional func willDismissDataPickerViewWithDoneButton(selectedRow: Int); // before animation and hiding view
    @objc optional func didDismissDataPickerViewWithDoneButton(selectedRow: Int); // after animation
}

@objc protocol DatePickerViewDelegate {

    // Called when a row is clicked. The view will be automatically dismissed after this call returns
    @objc optional func clickedRow(selectedDate: String);

    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button

    @objc optional func willPresentDatePickerView(selectedDateOrTime: String); // before animation and showing view
    @objc optional func didPresentDatePickerView(selectedDateOrTime: String); // // after animation

    @objc optional func willDismissDatePickerView();
    @objc optional func willDismissDatePickerViewWithDoneButton(selectedDateOrTime: String); // before animation and hiding view
    @objc optional func didDismissDatePickerViewWithDoneButton(selectedDateOrTime: String); // after animation
}

enum DatePickerMode: Int {
    case date = 0
    case time
    case data
}

class DatePickerView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var shadeView: UIView!
    var pickerContainer: UIView!

    private var animator: DatePickerViewAnimator!
    private weak var delegate: DatePickerViewDelegate?;
    private weak var dataSource: DataPickerViewDataSource?;
    private var pickerView: UIPickerView?
    private var datePicker: UIDatePicker?
    private var pickerMode: DatePickerMode = .date
    private var data: [String]?

    convenience init(dateMode: DatePickerMode, items: [String]?, delegate:DatePickerViewDelegate?, dataSource:DataPickerViewDataSource?) {
        self.init()
        self.animator = DatePickerViewAnimator()
        self.pickerMode = dateMode
        if dateMode == .data {
            self.data = items
            self.dataSource = dataSource
        } else {
            self.data = []
            self.delegate = delegate
        }
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.modalPresentationStyle = UIModalPresentationStyle.custom;
        self.transitioningDelegate = self.animator;
        self.modalPresentationCapturesStatusBarAppearance = true;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.updateLayout()
    }

    deinit {
    }

    public func showInViewController(viewController: UIViewController) {
        if self.isDateMode() {
            self.delegate?.willPresentDatePickerView?(selectedDateOrTime: self.selectedDateWithString())
        } else {
            self.dataSource?.willPresentDataPickerView?(dataPicker: self, selectedRow: self.selectedRow())
        }
        viewController.present(self, animated: true, completion: nil)
    }

    private func setup() {
        self.createShadeView()
        if self.isDateMode() {
            self.createDatePickerView()
        } else {
            self.createDataPickerView()
        }
    }

    private func createToolbar() -> UIToolbar {
        let rect = self.view.bounds
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: rect.size.width, height: 44));
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem.init(title: "cancel".localized(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.soOrangeColor], for: UIControlState.normal)
        let spaceButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(title: "done".localized(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.soOrangeColor], for: UIControlState.normal)
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        return toolbar
    }

    private func createShadeView() {
        let singleFingerTap = UITapGestureRecognizer.init(target: self, action: #selector(cancel))

        self.shadeView = UIView.init(frame: self.view.bounds)
        self.shadeView.backgroundColor = UIColor.black
        self.shadeView.alpha = 0;
        self.shadeView.addGestureRecognizer(singleFingerTap)
        self.view.addSubview(self.shadeView)
    }

    private func createDatePickerView() {
        var rect = self.view.bounds
        rect.size.height = 216

        self.pickerContainer = UIView.init(frame: CGRect.init(x: 0, y: self.view.bounds.height - rect.size.height - 44, width: rect.size.width, height: rect.size.height + 44))
        self.pickerContainer.backgroundColor = UIColor.white

        let  toolbar = self.createToolbar()
        self.pickerContainer.addSubview(toolbar)

        self.datePicker = UIDatePicker.init()
        self.updateLayout()
        self.pickerContainer.addSubview(self.datePicker!)
        if self.pickerMode == .date {
            let maxDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
            self.datePicker?.maximumDate = maxDate
            self.datePicker?.datePickerMode = UIDatePickerMode.date
        } else {
            datePicker?.datePickerMode = UIDatePickerMode.time
        }
        self.view.addSubview(self.pickerContainer)
    }

    private func createDataPickerView() {
        var rect = self.view.bounds
        rect.size.height = 216

        self.pickerContainer = UIView.init(frame: CGRect.init(x: 0, y: self.view.bounds.height - rect.size.height - 44, width: rect.size.width, height: rect.size.height + 44))
        self.pickerContainer.backgroundColor = UIColor.white
        self.pickerContainer.autoresizingMask = .flexibleWidth

        let  toolbar = self.createToolbar()
        self.pickerContainer.addSubview(toolbar)

        self.pickerView = UIPickerView.init()
        self.pickerView?.backgroundColor = UIColor.white
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.updateLayout()

        self.pickerContainer.addSubview(self.pickerView!)
        self.view.addSubview(self.pickerContainer)
    }

    func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        pickerView?.selectRow(row, inComponent: component, animated: animated)
    }

    private func updateLayout() {
        self.shadeView.frame = self.view.bounds
        var rect = self.view.bounds
        rect.size.height = 216
        if self.isDateMode() {
            self.datePicker?.frame = CGRect(x: 0, y: 44, width: rect.size.width, height: rect.size.height)
        } else {
            self.pickerView?.frame = CGRect(x: 0, y: 44, width: rect.size.width, height: rect.size.height)
        }
    }

    private func isDateMode() -> Bool {
        if self.pickerMode == DatePickerMode.data {
            return false
        }
        return true
    }

    @objc private func cancel() {
        self.dismisPicker()
    }

    private func dismisPicker() {
        if self.isDateMode() {
            self.delegate?.willDismissDatePickerView?()
        } else {
            self.dataSource?.willDismissDataPickerView?()
        }
        self.dismiss(animated: true, completion: nil)
    }

    // Mark: Tool bar

    @objc private func cancelPicker() {
        self.dismisPicker()
    }

    @objc private func donePicker() {
        if self.isDateMode() {
            let selectedDate = self.selectedDateWithString()
            self.delegate?.willDismissDatePickerViewWithDoneButton?(selectedDateOrTime: selectedDate)
            self.dismiss(animated: true) {
                self.delegate?.didDismissDatePickerViewWithDoneButton?(selectedDateOrTime: selectedDate)
            }
        } else {
            let selectedRow = self.selectedRow()
            self.dataSource?.willDismissDataPickerViewWithDoneButton?(selectedRow: selectedRow)
            self.dismiss(animated: true) {
                self.dataSource?.didDismissDataPickerViewWithDoneButton?(selectedRow: selectedRow)
            }
        }
    }

    // MARK: - Picker Methods

    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data!.count
    }

    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data?[row]
    }

    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dataSource?.didSelectRow?(row: row)
    }

    private func selectedDateWithString() -> String {
//        let selectedDate = self.datePicker?.date
        return ""
    }

    private func selectedRow() -> Int {
        return self.pickerView!.selectedRow(inComponent: 0)
    }

}
