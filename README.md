RMDateSelectionViewController
=============================

This is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like style

## Screenshots
### Portrait
![Portrait](http://cooperrs.github.io/RMDateSelectionViewController/Images/Screen-Portrait.png)

### Landscape
![Landscape](http://cooperrs.github.com/RMDateSelectionViewController/Images/Screen-Landscape.png)

##Usage
1. Import `RMDateSelectionViewController.h`
2. Implement the `RMDateSelectionViewControllerDelegate` protocol
	```objc
	@interface YourViewController () <RMDateSelectionViewControllerDelegate>
	@end
	```
	
	```objc
	#pragma mark - RMDAteSelectionViewController Delegates
	- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
		//Do something
	}

	- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
		//Do something else
	}
	```
4. Open date selection view controller
	```objc
	- (IBAction)openDateSelectionController:(id)sender {
    	RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    	dateSelectionVC.delegate = self;
    	
   		[dateSelectionVC show];
	}