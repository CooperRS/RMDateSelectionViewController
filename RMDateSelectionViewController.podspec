Pod::Spec.new do |s|
  s.name         = "RMDateSelectionViewController"
  s.platform     = :ios, "8.0"
  s.version      = "2.0.0"
  s.summary      = "This is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashion"
  s.homepage     = "https://github.com/CooperRS/RMDateSelectionViewController"
  s.screenshots  = "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait.png", "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Landscape.png", "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait-Black.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Roland Moers" => "rm@cooperrs.de" }
  s.source       = { :git => "https://github.com/CooperRS/RMDateSelectionViewController.git", :tag => "2.0.0" }
  s.source_files = 'RMDateSelectionViewController/*'
  s.requires_arc = true

  s.dependency   'RMActionController', '~> 1.0.0'
end
