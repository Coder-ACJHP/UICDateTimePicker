//
//  UICTimePicker.swift
//  UICHourPicker
//
//  Created by Coder ACJHP on 11.03.2019.
//  Copyright © 2019 FitBest Bilgi Teknolojileri. All rights reserved.
//

import UIKit

// Optional extension to call .xib files without
// writing class names as string
public extension NSObject {
    
    public class var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: self)
    }
}

protocol UICTimePickerDelegate: class {
    
    func valueDidChanged(_ timePicker: UICTimePicker, hour: Int, minute: Int)
}

class UICTimePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var selectedRowView: UIView!
    @IBOutlet private weak var selectedRowSeperatorView: UIView!
    @IBOutlet private weak var hourPicker: UIPickerView!
    @IBOutlet private weak var minutePicker: UIPickerView!
    
    public var selectedStartHour: Int = 0
    public var selectedStartMinute: Int = 0
    public var delegate: UICTimePickerDelegate?
    public var textColor: UIColor = .black
    public var selectedRowTextColor: UIColor = .black
    public var textFont: UIFont = UIFont.boldSystemFont(ofSize: 35)

    
    private var oldPickedHour: Int?
    private var oldPickedMinutes: Int?
    private var hours: [Int] = Array(0...24)
    private var minutes: [Int] = Array(0...59)
    private var isFirstReload = (0, 0)

    
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
        Bundle.main.loadNibNamed(UICTimePicker.className, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        adjustSelectedRowView()        
    }
    
    fileprivate func initializeSelf() {
        
        oldPickedHour = selectedStartHour
        oldPickedMinutes = selectedStartMinute
        
        self.hourPicker.reloadAllComponents()
        self.minutePicker.reloadAllComponents()
        self.hourPicker.selectRow(selectedStartHour, inComponent: 0, animated: false)
        self.minutePicker.selectRow(selectedStartMinute, inComponent: 0, animated: false)
    }

    fileprivate func adjustSelectedRowView() {
        
        selectedRowView.layer.cornerRadius = 32
        selectedRowView.layer.masksToBounds = true
        
        selectedRowSeperatorView.layer.cornerRadius = 5
        selectedRowSeperatorView.layer.masksToBounds = true
    }

    // Deleaget & data source methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPicker {
            return hours.count
        }
        return minutes.count
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
        // if is small than 10 to appear like 24 hour (00:00)
        if pickerView == hourPicker {
            
            if hours[row] < 10 {
                title = "0\(hours[row].description)"
            } else {
                title = hours[row].description
            }
            
        } else {

            if minutes[row] < 10 {
                title = "0\(minutes[row].description)"
            } else {
                title = minutes[row].description
            }
        }
        // Assign corrected title here
        label.text =  title
        
        // This part for re coloring selected rows at start
        // Variable 'isFirstLoad' = tuple including two variable (0,0)
        // If one of tuple values is 0 enter to is statement
        if isFirstReload != (1, 1) {
            // If picker is hour and row is at user selected start hour
            if pickerView == hourPicker && row == selectedStartHour {
                label.textColor = selectedRowTextColor
                isFirstReload.0 = 1
            } else if pickerView == minutePicker && row == selectedStartMinute {
                label.textColor = selectedRowTextColor
                isFirstReload.1 = 1
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
        
        // Enable minute picker interaction if disabled before
        // For stop changing minute when hour is 24
        if !minutePicker.isUserInteractionEnabled {
            minutePicker.isUserInteractionEnabled = true
        }
        
        // Make control point to check the which picker is moved
        if pickerView == hourPicker {
            // Store old hour to use it when picking minute
            oldPickedHour = hours[row]
            // If picked hour is 24 change minute to 0 and disable
            // scrolling to aviod choosing unavalible time;
            // because (24:00) is last time selectable in 24 system
            if oldPickedHour == hours.last {
                oldPickedMinutes = minutes[0]
                minutePicker.selectRow(0, inComponent: 0, animated: true)
                minutePicker.isUserInteractionEnabled = false
            }
            // Send delegate to super class (that implemented it)
            self.delegate?.valueDidChanged(self, hour: hours[row], minute: oldPickedMinutes ?? 0)
            
        } else {
            // Store old minute to use it when picking hour
            oldPickedMinutes = minutes[row]
            // Send delegate to super class (that implemented it)
            self.delegate?.valueDidChanged(self, hour: oldPickedHour ?? 0, minute: oldPickedMinutes ?? 0)
        }
    }
}
