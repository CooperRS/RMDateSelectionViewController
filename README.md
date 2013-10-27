RMDateSelectionViewController
=============================

This is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashion

## Screenshots
### Portrait
![Portrait](http://cooperrs.github.io/RMDateSelectionViewController/Images/Screen-Portrait.png)

### Landscape
![Landscape](http://cooperrs.github.com/RMDateSelectionViewController/Images/Screen-Landscape.png)

##Usage
1. Add all files in `RMDateSelectionViewController` folder to Xcode
2. Import `RMDateSelectionViewController.h` in your view controller
	
	```objc
	#import "RMDateSelectionViewController.h"
	```
3. Implement the `RMDateSelectionViewControllerDelegate` protocol
	
	```objc
	@interface YourViewController () <RMDateSelectionViewControllerDelegate>
	@end
	```
	
	```objc
	#pragma mark - RMDateSelectionViewController Delegates
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

## Requirements
Tested with:

* Xcode 5
* iOS 7 SDK
* ARC (You can turn it on and off on a per file basis)

May also work with previous Xcode and iOS SDK versions. But it will at least need a system capable of Autolayout (and I think it will look awful on iOS 6 ;)...)

## License (MIT License)
Copyright (c) 2013 Roland Moers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
