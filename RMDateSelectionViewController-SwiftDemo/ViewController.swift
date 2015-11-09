//
//  MasterViewController.swift
//  RMActionController-SwiftDemo
//
//  Created by Roland Moers on 19.08.15.
//  Copyright (c) 2015 Roland Moers. All rights reserved.
//

import UIKit
import RMDateSelectionViewController

class ViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var blurSwitch: UISwitch!
    @IBOutlet weak var motionSwitch: UISwitch!
    @IBOutlet weak var bouncingSwitch: UISwitch!
    
    // MARK: Actions
    func openDateSelectionViewController() {
        var style = RMActionControllerStyle.White
        if self.blackSwitch.on {
            style = RMActionControllerStyle.Black
        }
        
        let selectAction = RMAction(title: "Select", style: RMActionStyle.Done) { controller in
            if let dateController = controller as? RMDateSelectionViewController {
                print("Successfully selected date: ", dateController.datePicker.date);
            }
        }
        
        let cancelAction = RMAction(title: "Cancel", style: RMActionStyle.Cancel) { _ in
            print("Date selection was canceled")
        }
        
        let actionController = RMDateSelectionViewController(style: style, title: "Test", message: "This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.", selectAction: selectAction, andCancelAction: cancelAction)!;
        
        let in15MinAction = RMAction(title: "15 Min", style: .Additional) { controller -> Void in
            if let dateController = controller as? RMDateSelectionViewController {
                dateController.datePicker.date = NSDate(timeIntervalSinceNow: 15*60);
                print("15 Min button tapped");
            }
        }
        in15MinAction!.dismissesActionController = false;
        
        let in30MinAction = RMAction(title: "30 Min", style: .Additional) { controller -> Void in
            if let dateController = controller as? RMDateSelectionViewController {
                dateController.datePicker.date = NSDate(timeIntervalSinceNow: 30*60);
                print("30 Min button tapped");
            }
        }
        in30MinAction!.dismissesActionController = false;
        
        let in45MinAction = RMAction(title: "45 Min", style: .Additional) { controller -> Void in
            if let dateController = controller as? RMDateSelectionViewController {
                dateController.datePicker.date = NSDate(timeIntervalSinceNow: 45*60);
                print("45 Min button tapped");
            }
        }
        in45MinAction!.dismissesActionController = false;
        
        let in60MinAction = RMAction(title: "60 Min", style: .Additional) { controller -> Void in
            if let dateController = controller as? RMDateSelectionViewController {
                dateController.datePicker.date = NSDate(timeIntervalSinceNow: 60*60);
                print("60 Min button tapped");
            }
        }
        in60MinAction!.dismissesActionController = false;
        
        let groupedAction = RMGroupedAction(style: .Additional, andActions: [in15MinAction!, in30MinAction!, in45MinAction!, in60MinAction!]);
        actionController.addAction(groupedAction!);
        
        let nowAction = RMAction(title: "Now", style: .Additional) { controller -> Void in
            if let dateController = controller as? RMDateSelectionViewController {
                dateController.datePicker.date = NSDate();
                print("Now button tapped");
            }
        }
        nowAction!.dismissesActionController = false;
        
        actionController.addAction(nowAction!);
        
        //You can enable or disable blur, bouncing and motion effects
        actionController.disableBouncingEffects = !self.bouncingSwitch.on
        actionController.disableMotionEffects = !self.motionSwitch.on
        actionController.disableBlurEffects = !self.blurSwitch.on
        
        //You can access the actual UIDatePicker via the datePicker property
        actionController.datePicker.datePickerMode = .DateAndTime;
        actionController.datePicker.minuteInterval = 5;
        actionController.datePicker.date = NSDate(timeIntervalSinceReferenceDate: 0);
        
        //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
        //(Of course only if we are running on iOS 8 or later)
        if actionController.respondsToSelector(Selector("popoverPresentationController:")) && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            //First we set the modal presentation style to the popover style
            actionController.modalPresentationStyle = UIModalPresentationStyle.Popover
            
            //Then we tell the popover presentation controller, where the popover should appear
            if let popoverPresentationController = actionController.popoverPresentationController {
                popoverPresentationController.sourceView = self.tableView
                popoverPresentationController.sourceRect = self.tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            }
        }
        
        //Now just present the date selection controller using the standard iOS presentation method
        presentViewController(actionController, animated: true, completion: nil)
    }
    
    // MARK: UITableView Delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            openDateSelectionViewController()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

