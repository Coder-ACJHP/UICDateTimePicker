# UICDateTimePicker
New look for date &amp; time picker in Swift 4+

<div style="display: block; width: 1000px;">
  
  <div style="display: inline-block; margin: 15px;">
    <h3>UICTimePicker screen shot</h3>
    <img src="https://github.com/Coder-ACJHP/UICDateTimePicker/blob/master/Simulator%20Screen%20Shot.png" width=300 height= 500>
  </div>

  <div style="display: inline-block; margin: 15px;">
    <h3>UICDatePicker screen shot</h3>
    <img src="https://github.com/Coder-ACJHP/UICDateTimePicker/blob/master/Simulator%20Screen%20Shot2.png" width=300 height= 500>
  </div>
  
</div>

## How to implement it?
###### Note: UICDatePicker and UICTimePicker is seperated files you can use one of them so you must copy ".swift & .xib" file for per picker. For ex: UICDatePicker.swift & UICDatePicker.xib
###### 1 - Download this project and easily you can drag component you want from Component folder into your project 
###### 2 - Following code will show you how you can implement it (you can Copy and paste in your VC)

<pre>
<code>

import UIKit

class ViewController: UIViewController {

   var datePicker: UICDatePicker! 
 
   override func viewDidLoad() {
        super.viewDidLoad()
                
        addDatePickerView()
    }

   fileprivate func addDatePickerView() {

        let datePickerFrame = CGRect(x: 0, y: 0, width: 353, height: 194)
        datePicker = UICDatePicker(frame: datePickerFrame)
        datePicker.textColor = unSelectedTextColor 
        datePicker.selectedRowTextColor = bgColor  
        datePicker.textFont = UIFont.boldSystemFont(ofSize: 30)
        datePicker.setTodayAsDefaultDate = true    
        datePicker.delegate = self

        self.view.addSubview(datePicker)
        datePicker.center = self.view.center

    }
}
extension ViewController: UICDatePickerDelegate {
   func valueDidChanged(_ datePicker: UICDatePicker, day: Int, month: Int, year: Int) {
       debugPrint("Picked date: \(day) / \(month) / \(year)")
   }
}


/////////////////////////////////////////////////////////////////////////////////////////////////


import UIKit

class ViewController: UIViewController {

   var timePicker: UICTimePicker! 
 
   override func viewDidLoad() {
        super.viewDidLoad()
                
        addTimePickerView()
    }

   fileprivate func addTimePickerView() {

        let timePickerFrame = CGRect(x: 0, y: 0, width: 225, height: 194)
        timePicker = UICTimePicker(frame: timePickerFrame)
        timePicker.textColor = unSelectedTextColor
        timePicker.selectedRowTextColor = bgColor
        timePicker.selectedStartHour = 6
        timePicker.selectedStartMinute = 30
        timePicker.delegate = self

        self.view.addSubview(timePicker)
        timePicker.center = self.view.center

    }
}
extension ViewController: UICTimePickerDelegate {
    func valueDidChanged(_ timePicker: UICTimePicker, hour: Int, minute: Int) {
        debugPrint("Picked hour: \(hour) & minute: \(minute)")
    }
}
</code>
</pre>
