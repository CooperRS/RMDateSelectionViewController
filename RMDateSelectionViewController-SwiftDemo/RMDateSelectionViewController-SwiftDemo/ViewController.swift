//
//  ViewController.swift
//  RMDateSelectionViewController-SwiftDemo
//
//  Created by Ricardo Pereira on 12/08/2015.
//
//

import UIKit
import RMDateSelectionViewController

class ViewController: UITableViewController {
    
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var blurSwitch: UISwitch!
    @IBOutlet weak var motionSwitch: UISwitch!
    @IBOutlet weak var bouncingSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            openDateSelectionController()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func openDateSelectionController() {
        var style = RMActionControllerStyle.White
        if self.blackSwitch.on {
            style = RMActionControllerStyle.Black
        }
        
        let selectAction = RMAction(title: "Select", style: RMActionStyle.Done) { controller in
            println("Successfully selected date: \((controller.contentView as! UIDatePicker).date)")
        }
        
        let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel) { _ in
            println("Date selection was canceled")
        }
        
        let dateSelectionController = RMDateSelectionViewController(style: style)
        dateSelectionController.title = "Test"
        dateSelectionController.message = "This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'."
        
        dateSelectionController.addAction(selectAction)
        dateSelectionController.addAction(cancelAction)
        
        let in15MinAction = RMAction(title: "15 Min", style: RMActionStyle.Additional) { controller in
            if let datePicker = controller.contentView as? UIDatePicker {
                datePicker.date = NSDate(timeIntervalSinceNow: 15*60)
            }
            println("15 Min button tapped")
        }
        in15MinAction.dismissesActionController = false
        
        let in30MinAction = RMAction(title: "30 Min", style: RMActionStyle.Additional) { controller in
            if let datePicker = controller.contentView as? UIDatePicker {
                datePicker.date = NSDate(timeIntervalSinceNow: 30*60)
            }
            println("30 Min button tapped")
        }
        in30MinAction.dismissesActionController = false
        
        let in45MinAction = RMAction(title: "45 Min", style: RMActionStyle.Additional) { controller in
            if let datePicker = controller.contentView as? UIDatePicker {
                datePicker.date = NSDate(timeIntervalSinceNow: 45*60)
            }
            println("45 Min button tapped")
        }
        in45MinAction.dismissesActionController = false

        let in60MinAction = RMAction(title: "60 Min", style: RMActionStyle.Additional) { controller in
            if let datePicker = controller.contentView as? UIDatePicker {
                datePicker.date = NSDate(timeIntervalSinceNow: 60*60)
            }
            println("60 Min button tapped")
        }
        in60MinAction.dismissesActionController = false
        
        let groupedAction = RMGroupedAction(style: RMActionStyle.Additional, andActions: [in15MinAction, in30MinAction, in45MinAction, in60MinAction])
        
        dateSelectionController.addAction(groupedAction)
        
        let nowAction = RMAction(title: "Now", style: RMActionStyle.Additional) { controller in
            if let datePicker = controller.contentView as? UIDatePicker {
                datePicker.date = NSDate()
            }
            println("Now button tapped")
        }
        nowAction.dismissesActionController = false
        
        dateSelectionController.addAction(nowAction)
        
        //You can enable or disable blur, bouncing and motion effects
        dateSelectionController.disableBouncingEffects = !self.bouncingSwitch.on
        dateSelectionController.disableMotionEffects = !self.motionSwitch.on
        dateSelectionController.disableBlurEffects = !self.blurSwitch.on

        //You can access the actual UIDatePicker via the datePicker property
        if let datePicker = dateSelectionController.datePicker {
            datePicker.datePickerMode = UIDatePickerMode.DateAndTime
            datePicker.minuteInterval = 5
            datePicker.date = NSDate(timeIntervalSinceReferenceDate: 0)
        }
        
        //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
        //(Of course only if we are running on iOS 8 or later)
        if dateSelectionController.respondsToSelector(Selector("popoverPresentationController:")) && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            //First we set the modal presentation style to the popover style
            dateSelectionController.modalPresentationStyle = UIModalPresentationStyle.Popover
            
            //Then we tell the popover presentation controller, where the popover should appear
            if let popoverPresentationController = dateSelectionController.popoverPresentationController {
                popoverPresentationController.sourceView = self.tableView
                popoverPresentationController.sourceRect = self.tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            }
        }

        //Now just present the date selection controller using the standard iOS presentation method
        presentViewController(dateSelectionController, animated: true, completion: nil)
    }

}

