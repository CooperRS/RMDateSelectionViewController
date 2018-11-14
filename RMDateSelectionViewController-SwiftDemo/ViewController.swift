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
    @IBOutlet weak var blurActionSwitch: UISwitch!
    @IBOutlet weak var motionSwitch: UISwitch!
    @IBOutlet weak var bouncingSwitch: UISwitch!
    
    // MARK: Actions
    func openDateSelectionViewController() {
        var style = RMActionControllerStyle.white
        if self.blackSwitch.isOn {
            style = RMActionControllerStyle.black
        }
        
        let selectAction = RMAction<UIDatePicker>(title: "Select", style: RMActionStyle.done) { controller in
            print("Successfully selected date: ", controller.contentView.date);
        }
        
        let cancelAction = RMAction<UIDatePicker>(title: "Cancel", style: RMActionStyle.cancel) { _ in
            print("Date selection was canceled")
        }
        
        let actionController = RMDateSelectionViewController(style: style, title: "Test", message: "This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.", select: selectAction, andCancel: cancelAction);
        
        let in15MinAction = RMAction<UIDatePicker>(title: "15 Min", style: .additional) { controller -> Void in
            controller.contentView.date = Date(timeIntervalSinceNow: 15*60);
            print("15 Min button tapped");
        }
        in15MinAction.dismissesActionController = false;
        
        let in30MinAction = RMAction<UIDatePicker>(title: "30 Min", style: .additional) { controller -> Void in
            controller.contentView.date = Date(timeIntervalSinceNow: 30*60);
            print("30 Min button tapped");
        }
        in30MinAction.dismissesActionController = false;
        
        let in45MinAction = RMAction<UIDatePicker>(title: "45 Min", style: .additional) { controller -> Void in
            controller.contentView.date = Date(timeIntervalSinceNow: 45*60);
            print("45 Min button tapped");
        }
        in45MinAction.dismissesActionController = false;
        
        let in60MinAction = RMAction<UIDatePicker>(title: "60 Min", style: .additional) { controller -> Void in
            controller.contentView.date = Date(timeIntervalSinceNow: 60*60);
            print("60 Min button tapped");
        }
        in60MinAction.dismissesActionController = false;
        
        let groupedAction = RMGroupedAction<UIDatePicker>(style: .additional, andActions: [in15MinAction, in30MinAction, in45MinAction, in60MinAction]);
        actionController.addAction(groupedAction!);
        
        let nowAction = RMAction<UIDatePicker>(title: "Now", style: .additional) { controller -> Void in
            controller.contentView.date = Date();
            print("Now button tapped");
        }
        nowAction.dismissesActionController = false;
        
        actionController.addAction(nowAction);
        
        //You can enable or disable blur, bouncing and motion effects
        actionController.disableBouncingEffects = !self.bouncingSwitch.isOn
        actionController.disableMotionEffects = !self.motionSwitch.isOn
        actionController.disableBlurEffects = !self.blurSwitch.isOn
        actionController.disableBlurEffectsForActions = !self.blurActionSwitch.isOn
        
        //You can access the actual UIDatePicker via the datePicker property
        actionController.datePicker.datePickerMode = .dateAndTime;
        actionController.datePicker.minuteInterval = 5;
        actionController.datePicker.date = Date(timeIntervalSinceReferenceDate: 0);
        
        //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
        //(Of course only if we are running on iOS 8 or later)
        if actionController.responds(to: Selector(("popoverPresentationController:"))) && UIDevice.current.userInterfaceIdiom == .pad {
            //First we set the modal presentation style to the popover style
            actionController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            //Then we tell the popover presentation controller, where the popover should appear
            if let popoverPresentationController = actionController.popoverPresentationController {
                popoverPresentationController.sourceView = self.tableView
                popoverPresentationController.sourceRect = self.tableView.rectForRow(at: IndexPath.init(row: 0, section: 0))
            }
        }
        
        //Now just present the date selection controller using the standard iOS presentation method
        present(actionController, animated: true, completion: nil)
    }
    
    // MARK: UITableView Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
            openDateSelectionViewController()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

