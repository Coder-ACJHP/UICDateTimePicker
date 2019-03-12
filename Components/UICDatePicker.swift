//
//  UICDatePicker.swift
//  UICHourPicker
//
//  Created by akademobi5 on 11.03.2019.
//  Copyright © 2019 FitBest Bilgi Teknolojileri. All rights reserved.
//

import UIKit

protocol UICDatePickerDelegate: NSObjectProtocol {
    
    func valueDidChanged(_ datePicker: UICDatePicker, day: Int, month: Int, year: Int)
}

class UICDatePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var dayPicker: UIPickerView!
    @IBOutlet private weak var monthPicker: UIPickerView!
    @IBOutlet private weak var yearPicker: UIPickerView!
    @IBOutlet private weak var seperatorView1: UIView!
    @IBOutlet private weak var seperatorView2: UIView!
    @IBOutlet private weak var seperatorContainerView: UIView!
    
    private var oldPickedDay: Int?
    private var oldPickedMonth: Int?
    private var oldPickedYear: Int?
    private var days: [Int] = Array(1...31)
    private var months: [Int] = Array(1...12)
    private var years: [Int] = Array(1970...2037)
    private var isFirstReload = (0, 0, 0)
    
    public var defaultDay: Int = 0
    public var defaultMonth: Int = 0
    public var defaultYear: Int = 0
    public var delegate: UICDatePickerDelegate?
    public var setTodayAsDefaultDate: Bool = false
    public var textColor: UIColor = .black
    public var selectedRowTextColor: UIColor = .black
    public var textFont: UIFont = UIFont.boldSystemFont(ofSize: 35)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initializeSelf()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed(UICDatePicker.className, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.dayPicker.delegate = self
        self.dayPicker.dataSource = self
        self.monthPicker.delegate = self
        self.monthPicker.dataSource = self
        self.yearPicker.delegate = self
        self.yearPicker.dataSource = self
        
        adjustSelectedRowView()
    }

    private func adjustSelectedRowView() {
        
        seperatorContainerView.layer.cornerRadius = 32
        seperatorContainerView.layer.masksToBounds = true
        
        seperatorView1.layer.cornerRadius = 5
        seperatorView1.layer.masksToBounds = true
        
        seperatorView2.layer.cornerRadius = 5
        seperatorView2.layer.masksToBounds = true
    }
    
    private func initializeSelf() {

            
        oldPickedDay = defaultDay
        oldPickedMonth = defaultMonth
        oldPickedYear = defaultYear
        
        self.dayPicker.reloadAllComponents()
        self.monthPicker.reloadAllComponents()
        self.yearPicker.reloadAllComponents()
        
        if setTodayAsDefaultDate {
            
            self.setTodayAsDefaultDate = false
            
            let date = Date()
            
            let day = Calendar.current.component(.day, from: date)
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            
            oldPickedDay = day
            oldPickedMonth = month
            oldPickedYear = year
            
            setDate(day: day, month: month, year: year)
            
        } else {
            
            setDate(day: defaultDay, month: defaultMonth, year: defaultYear)
        }
        
    }
    
    
    public func setDate(day: Int, month: Int, year: Int) {
        
        let givenDayIndex = getIndexFor(number: day, inList: days)
        self.dayPicker.selectRow(givenDayIndex, inComponent: 0, animated: true)
        
        let givenMonthIndex = getIndexFor(number: month, inList: months)
        self.monthPicker.selectRow(givenMonthIndex, inComponent: 0, animated: true)
        
        let givenYearIndex = getIndexFor(number: year, inList: years)
        self.yearPicker.selectRow(givenYearIndex, inComponent: 0, animated: true)
    }
    
    private func getIndexFor(number: Int, inList: [Int]) -> Int {
        
        var indexNum = Int()
        
        for (index, item) in inList.enumerated() {
            if number.description == item.description {
                indexNum = index
                break
            }
        }
        return indexNum
    }
    
    // Deleaget & data source methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dayPicker {
            return days.count
        } else if pickerView == monthPicker {
            return months.count
        }
        
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        // I like to show just three numbers on pickers
        return self.contentView.bounds.height / 3
    }
    
    // Get all row's component to make some changes
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // Define variables
        var label = UILabel()
        var title = String()
        // if current view is UILabel assing it to custom defianed label
        if let v = view as? UILabel { label = v }
        // Change text font here
        label.font = textFont
        
        // Add control point to paste 0 before to current row title
        if pickerView == dayPicker {
            title = days[row].description
        } else if pickerView == monthPicker {
            title = months[row].description
        } else {
            title = years[row].description
        }
        // Assign corrected title here
        label.text =  title
        
        // This part for re coloring selected rows at start
        // Variable 'isFirstLoad' = tuple including two variable (0,0)
        // If one of tuple values is 0 enter to is statement
        if isFirstReload != (1, 1, 1) {
            // If picker is hour and row is at user selected start hour
            if pickerView == dayPicker && row == defaultDay {
                label.textColor = selectedRowTextColor
                isFirstReload.0 = 1
            } else if pickerView == monthPicker && row == defaultMonth {
                label.textColor = selectedRowTextColor
                isFirstReload.1 = 1
            } else if pickerView == yearPicker && row == defaultYear {
                label.textColor = selectedRowTextColor
                isFirstReload.2 = 1
            } else {
                label.textColor = textColor
            }
        } else {
            label.textColor = textColor
        }
        
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        return label
    }
    
    // Do something when user select row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Change selected row label color for both pickers
        if let selectedRowLabel = pickerView.view(forRow: row, forComponent: component) as? UILabel {
            selectedRowLabel.textColor = selectedRowTextColor
        }
        
        // Make control point to check the which picker is moved
        if pickerView == dayPicker {
            // Store old hour to use it when picking minute
            oldPickedDay = days[row]

            // Send delegate to super class (that implemented it)
            self.delegate?.valueDidChanged(self, day: days[row], month: oldPickedMonth ?? 0, year: oldPickedYear ?? 0)
            
        } else if pickerView == monthPicker {
            oldPickedMonth = months[row]
            // Send delegate to super class (that implemented it)
            self.delegate?.valueDidChanged(self, day: oldPickedDay ?? 0, month: months[row], year: oldPickedYear ?? 0)
            
        } else {
            // Store old minute to use it when picking hour
            oldPickedYear = years[row]
            // Send delegate to super class (that implemented it)
            self.delegate?.valueDidChanged(self, day: oldPickedDay ?? 0, month: oldPickedMonth ?? 0, year: years[row])
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
