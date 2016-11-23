Pod::Spec.new do |s|
  s.name         = "RMDateSelectionViewController"
  s.version      = "2.2.0"
  s.platform     = :ios, "8.0"
  s.summary      = "This is an iOS control for selecting a date using UIDatePicker in a UIAlertController like manner"
  s.description  = "This framework allows you to select a date by presenting an action sheet. In addition, it allows you to add actions arround the presented date picker which behave like a button and can be tapped by the user. The result looks very much like an UIActionSheet or UIAlertController with a UIDatePicker and some UIActions attached."

  s.homepage     = "https://github.com/CooperRS/RMDateSelectionViewController"
  s.screenshots  = "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait.png", "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Landscape.png", "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait-Black.png"
  
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Roland Moers" => "rm@cooperrs.de" }
  
  s.source       = { :git => "https://github.com/CooperRS/RMDateSelectionViewController.git", :tag => "2.2.0" }
  s.source_files = 'RMDateSelectionViewController/*.{h,m}'
  s.requires_arc = true

  s.dependency   'RMActionController', '~> 1.2.0'
end
