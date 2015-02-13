RMDateSelectionViewController
=============================

This is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashion

## Screenshots
### Portrait
![Portrait](http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait.png)

### Landscape
![Landscape](http://cooperrs.github.com/RMDateSelectionViewController/Images/Blur-Screen-Landscape.png)

### Black version
![Colors](http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait-Black.png)

##Installation
###CocoaPods
```ruby
platform :ios, '7.0'
pod "RMDateSelectionViewController", "~> 1.4.3"
```

###Manual
1. Check out the project
2. Add all files in `RMDateSelectionViewController` folder to Xcode

##Usage
###Basic
1. Import `RMDateSelectionViewController.h` in your view controller
	
	```objc
	#import "RMDateSelectionViewController.h"
	```
2. Implement the `RMDateSelectionViewControllerDelegate` protocol
	
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
	
3. Open date selection view controller
	
	```objc
	- (IBAction)openDateSelectionController:(id)sender {
    	RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    	dateSelectionVC.delegate = self;
    	
   		[dateSelectionVC show];
	}
	```

###Advanced
Every RMDateSelectionViewController has a property datePicker. It is available after `show` has been called. With this property you have total control over the UIDatePicker that is shown in the screen.

Additionally, there is a method called `showFromViewController:`. With this method you can control where the your date picker is shown. For example on an iPad this method can be used to show the date picker in a popover.

###How to localize the buttons? 
[Localization](https://github.com/CooperRS/RMDateSelectionViewController/wiki/Localization)

## Documentation
There is an additional documentation available provided by the CocoaPods team. Take a look at [cocoadocs.org](http://cocoadocs.org/docsets/RMDateSelectionViewController/).

## Requirements
Works with:

* Xcode 6
* iOS 8 SDK
* ARC (You can turn it on and off on a per file basis)

iOS 8 SDK is only needed for compiling (as it uses the blur features provided by iOS 8 SDK). At runtime the control only needs iOS 7 or later.

If you absolutely need to use iOS 7 SDK you can take a look at the iOS 7 branch called [1.3.x](https://github.com/CooperRS/RMDateSelectionViewController/tree/1.3.x)

## Apps using this control
Using this control in your app or know anyone who does?

Feel free to add the app to this list: [Apps using RMDateSelectionViewController](https://github.com/CooperRS/RMDateSelectionViewController/wiki/Apps-using-RMDateSelectionViewController)

##Credits
Localizations:
* Robin Franssen (Dutch)
* Anton Rusanov (Russian)
* Pedro Ventura (Spanish)
* Vincent Xue (Chinese)
* Vinh Nguyen (Vietnamese)

Code contributions:
* Robin Franssen
	* Block support
* Digeon Benjamin 
	* Delegate method when now button is pressed
	* Cancel delegate method is called when background view is tapped
* Denis Andrasec
	* Bugfixes
* AnthonyMDev
	* Cancel delegate method should be optional
* steveoleary
	* Bugfixes

I want to thank everyone who has contributed code and/or time to this project!

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
