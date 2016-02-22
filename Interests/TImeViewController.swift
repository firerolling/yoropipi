//
//  ViewController.swift
//  CVCalendar Demo
//
//  Created by Мак-ПК on 1/3/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
  
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var selectedDateAndTime: UILabel!
    @IBOutlet weak var timePicker:UIDatePicker!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var selectedDay:DayView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        monthLabel.text = CVDate(date: NSDate()).globalDescription
    
        
        
    }

    @IBAction func changeDate(sender: UIDatePicker) {
        
            
            // 表示書式の設定
            
            let df:NSDateFormatter = NSDateFormatter()
            
            //df.dateFormat = "yyyy年MM月dd日 "//年月日時分
            //df.dateFormat = "yyyy年MM月dd日 HH時" //年月日時
            //df.dateFormat = "yyyy年M月dd日 " //年月日（月０なし）
            
            df.dateFormat = "HH:mm " //年月日（月０日０なし）
            
            // 選択日時の表示
            
            let mySelectedDate: NSString = df.stringFromDate(sender.date)
            self.selectedDateAndTime.text = mySelectedDate as String
        
    }
    
    
    @IBAction func sendDateAndTIme(sender: UIButton) {
        
        print(selectedDate.text! + "   " + selectedDateAndTime.text!)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension TimeViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
        self.selectedDate.text = dayView.date.commonDescription
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }

    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
   }


// MARK: - CVCalendarViewAppearanceDelegate

extension TimeViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension TimeViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension TimeViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
//        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
//        let calendar = NSCalendar.currentCalendar()
//        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
//        let calendar = NSCalendar.currentCalendar()
//        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}