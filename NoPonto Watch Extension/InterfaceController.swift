//
//  InterfaceController.swift
//  NoPonto Watch Extension
//
//  Created by Bruno Cortez on 3/18/20.
//  Copyright © 2020 Bruno Cortez. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var btTimer: WKInterfaceButton!
    @IBOutlet weak var textGroup: WKInterfaceGroup!
    @IBOutlet weak var slider: WKInterfaceSlider!
    @IBOutlet weak var lbCook: WKInterfaceLabel!
    @IBOutlet weak var lbWeight: WKInterfaceLabel!
    @IBOutlet weak var imageGroup: WKInterfaceGroup!
    @IBOutlet weak var weightPicker: WKInterfacePicker!
    @IBOutlet weak var lbTemperature: WKInterfaceLabel!
    @IBOutlet weak var temperaturePicker: WKInterfacePicker!
    
    var timerRunning: Bool = false
    var kg: Double = 0.1
    var increment: Double = 0.1
    var cookTemp: MeatTemperature = .rare
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        updateConfiguration()
        imageGroup.setHidden(true)
        setupPickers()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func onTimerButton() {
        if (timerRunning) {
            timer.stop()
            btTimer?.setTitle("Start Timer")
        }
        else {
            btTimer?.setTitle("Stop Timer")
            let time = cookTemp.cookTimeForKg(kg)
            let date = Date(timeIntervalSinceNow: time)
            timer.setDate(date)
            timer.start()
        }
        timerRunning.toggle()
    }
    
    @IBAction func onMinusButton() {
        if (kg > 0.1) {
            kg -= increment
            updateConfiguration()
        }
    }
    
    @IBAction func onPlusButton() {
        if (kg < 1.0) {
            kg += increment
            updateConfiguration()
        }
    }
    
    @IBAction func onTempChange(_ value: Float) {
        if let temp = MeatTemperature(rawValue:Int(value)) {
            cookTemp = temp
            updateConfiguration()
        }
    }
    
    @IBAction func onWeightChange(_ value: Int) {
        kg = Double(value + 1) * increment
        updateConfiguration()
    }
    
    
    @IBAction func onTemperatureChange(_ value: Int) {
        cookTemp = MeatTemperature(rawValue: value)!
        updateConfiguration()
        slider.setValue(Float(value))
    }
    
    
    @IBAction func onModeChange(_ value: Bool) {
        imageGroup.setHidden(!value)
        textGroup.setHidden(value)
        updateConfiguration()
        
//        let weightPickerIndex: Int = Int(kg/increment)
        let weightPickerIndex: Int = Int(round(kg/increment)-1)
        weightPicker.setSelectedItemIndex(weightPickerIndex)
    }
    
    func get2DecimalPlaces(for number: Double) -> Double {
        return Double(round(number*100)/100)
    }
    
    
    func updateConfiguration() {
        kg = get2DecimalPlaces(for: kg)
        lbWeight.setText("Total: \(kg) kg")
        lbCook.setText(cookTemp.stringValue)
        temperaturePicker.setSelectedItemIndex(cookTemp.rawValue)
        lbTemperature.setText(cookTemp.stringValue)
    }
    
    func setupPickers() {
        setupQuantityPicker()
        setupTemperaturePicker()
    }
    
    func setupQuantityPicker() {
        var weightItems: [WKPickerItem] = []
        for number in stride(from: 0.1, through: 1.0, by: increment) {
            let item = WKPickerItem()
            item.title = "\(get2DecimalPlaces(for: number))"
            weightItems.append(item)
        }
        weightPicker.setItems(weightItems)
        weightPicker.setSelectedItemIndex(0)
    }
    
    func setupTemperaturePicker() {
        var tempItems: [WKPickerItem] = []
        for index in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(index)")
            tempItems.append(item)
        }
        temperaturePicker.setItems(tempItems)
        temperaturePicker.setSelectedItemIndex(0)
    }
    
}
