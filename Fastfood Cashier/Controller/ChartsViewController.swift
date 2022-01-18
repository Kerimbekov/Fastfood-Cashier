//
//  ChartsViewController.swift
//  Fastfood Cashier
//
//  Created by Нуржан Керимбеков on 2021-11-11.
//

import UIKit
import RealmSwift
import Charts

class ChartsViewController: UIViewController,ChartViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var allSumLabel: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var tEmptyView: UIView!
    @IBOutlet weak var tDayView: UIView!
    @IBOutlet weak var tWeekView: UIView!
    @IBOutlet weak var tMonthView: UIView!
    @IBOutlet weak var tYearView: UIView!
    @IBOutlet weak var averageView: UIView!
    @IBOutlet weak var dayAverageView: UIView!
    @IBOutlet weak var weekAverageView: UIView!
    @IBOutlet weak var monthAverageView: UIView!
    @IBOutlet weak var yearAverageView: UIView!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var dayCurrentView: UIView!
    @IBOutlet weak var weekCurrentView: UIView!
    @IBOutlet weak var monthCurrentView: UIView!
    @IBOutlet weak var yearCurrentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dayAverageLabel: UILabel!
    @IBOutlet weak var weekAverageLabel: UILabel!
    @IBOutlet weak var monthAverageLabel: UILabel!
    @IBOutlet weak var yearAverageLabel: UILabel!
    @IBOutlet weak var dayCurrentLabel: UILabel!
    @IBOutlet weak var weekCurrentLabel: UILabel!
    @IBOutlet weak var monthCurrentLabel: UILabel!
    @IBOutlet weak var yearCurrentLabel: UILabel!
    
    var list:Results<OrderListItem>?
    var filteredList:Results<OrderListItem>?
    var chosenDate = Date().localDate()
    var sumOfOrders = 0.0
    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            list = realm.objects(OrderListItem.self).filter("served = %@", true)
        } catch  {
            print("error getting orders in Charts")
        }
        barChart.delegate = self
        myDatePicker.date = Date().localDate()
        
        ConfigureUI()
        setFields()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 10, y: 10, width: chartView.frame.width - 20, height: chartView.frame.height - 20)
        chartView.addSubview(barChart)
        barChart.centerXAnchor.constraint(equalTo: chartView.centerXAnchor).isActive = true
        barChart.centerYAnchor.constraint(equalTo: chartView.centerYAnchor).isActive = true
        chartView.layer.cornerRadius = 8
        chartView.makeBigBorder()
        setChart()
    }
    
    func setChart(){
        var entries = [BarChartDataEntry]()
        
        if let list = list, list.count > 0{
            let firstOrder = list.first
            let firstDate = firstOrder!.date.beginningOfDay()
            var days = Calendar.current.dateComponents([.day], from: firstDate, to: chosenDate).day ?? 0

            var startInt = -1
            var endInt = days
            if days > 30 {
                startInt = endInt - 30
            }
            var i = 0
            for index in stride(from: endInt, to: startInt, by: -1){
                var sum = 0.0
                var dateComponents = DateComponents()
                dateComponents.day = -index
                var beginDate = Calendar.current.date(byAdding: dateComponents, to: chosenDate)
                beginDate = beginDate?.beginningOfDay()
                
                dateComponents.day = 1
                let endDate = Calendar.current.date(byAdding: dateComponents, to: beginDate!)
                print(index)
                print(beginDate)
                print(endDate)
                
                filteredList = list.filter("date < %@ AND date > %@",endDate,beginDate)
                if filteredList?.count ?? 0 > 0{
                    sum = getIncome(myList: filteredList!)
                }
                
                i += 1
                entries.append(BarChartDataEntry(x: Double(i), y: sum))
            }
        }
        
        let set = BarChartDataSet(entries)
        set.stackLabels = ["Days"]
        set.colors = ChartColorTemplates.pastel()
        let data = BarChartData(dataSet: set)
        barChart.data = data
        barChart.drawBordersEnabled = true
    }
    
    func ConfigureUI(){
        mainView.makeRoundedByEight()
        headerView.makeRoundedByEight()
        mainStackView.makeRoundedByEight()
        mainStackView.makeBigBorder()
        headerView.makeShadow()
        mainView.makeShadow()
    }
    
    func setFields(){
        nameLabel.text = UserDefaults.standard.string(forKey: K.Defaults.companyName)
        chosenDate = myDatePicker.date
        setAllIncome()
        setCurrentDay()
        setCurrentWeek()
        setCurrentMonth()
        setCurrentYear()
        getAverages()
    }
    @IBAction func dateChanged(_ sender: Any) {
        chosenDate = myDatePicker.date.localDate()
        setFields()
        setChart()
    }
    
    func setAllIncome(){
        if list?.count ?? 0 > 0{
            sumOfOrders = getIncome(myList: list!)
            allSumLabel.text = String(sumOfOrders)
        }else{
            allSumLabel.text = "0"
        }
    }
    
    func setCurrentDay(){
        let pastDate = chosenDate.beginningOfDay()
        filteredList = list?.filter("date < %@ AND date > %@",chosenDate,pastDate)
        if filteredList?.count ?? 0 > 0{
            dayCurrentLabel.text = String(getIncome(myList: filteredList!))
        }else{
            dayCurrentLabel.text = "0"
        }
    }
    
    func setCurrentWeek(){
        var dateComponents = DateComponents()
        dateComponents.day = -7
        let pastDate = Calendar.current.date(byAdding: dateComponents, to: chosenDate)
        filteredList = list?.filter("date < %@ AND date > %@",chosenDate,pastDate!)
        if filteredList?.count ?? 0 > 0{
            weekCurrentLabel.text = String(getIncome(myList: filteredList!))
        }else{
            weekCurrentLabel.text = "0"
        }
        
    }
    
    func setCurrentMonth(){
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let pastDate = Calendar.current.date(byAdding: dateComponents, to: chosenDate)
        filteredList = list?.filter("date < %@ AND date > %@",chosenDate,pastDate!)
        if filteredList?.count ?? 0 > 0{
            monthCurrentLabel.text = String(getIncome(myList: filteredList!))
        }else{
            monthCurrentLabel.text = "0"
        }
    }
    
    func setCurrentYear(){
        var dateComponents = DateComponents()
        dateComponents.year = -1
        let pastDate = Calendar.current.date(byAdding: dateComponents, to: chosenDate)
        filteredList = list?.filter("date < %@ AND date > %@",chosenDate,pastDate!)
        if filteredList?.count ?? 0 > 0{
            yearCurrentLabel.text = String(getIncome(myList: filteredList!))
        }else{
            yearCurrentLabel.text = "0"
        }
    }
    
    func getIncome(myList: Results<OrderListItem>) -> Double{
        var sum = 0.0
        for order in myList{
            sum = sum + order.sum
        }
        return sum
    }
    
    func getAverages(){
        if let list = list, list.count > 0{
            
            let firstOrder = list.first
            let firstDate = firstOrder!.date.beginningOfDay()
            var days = Calendar.current.dateComponents([.day], from: firstDate, to: chosenDate).day ?? 0
            days += 1
            dayAverageLabel.text = String(sumOfOrders / Double(days))
            
            var weeks = days / 7
            weeks += 1
            weekAverageLabel.text = String(sumOfOrders / Double(weeks))
            
            var months = Calendar.current.dateComponents([.month], from: firstDate, to: chosenDate).month ?? 0
            months += 1
            monthAverageLabel.text = String(sumOfOrders / Double(months))
            
            var years = Calendar.current.dateComponents([.year], from: firstDate, to: chosenDate).year ?? 0
            years += 1
            yearAverageLabel.text = String(sumOfOrders / Double(years))
            
            
        }
        
    }
   

}
