Pod::Spec.new do |s|
  s.name         = "RMDateSelectionViewController"
  s.version      = "1.4.3"
  s.summary      = "iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashion"
  s.homepage     = "https://github.com/CooperRS/RMDateSelectionViewController"
  s.screenshots  = "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait.png", "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Landscape.png", "http://cooperrs.github.io/RMDateSelectionViewController/Images/Blur-Screen-Portrait-Black.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Roland Moers" => "rm@cooperrs.de" }
  s.source       = { :git => "https://github.com/CooperRS/RMDateSelectionViewController.git", :tag => "1.4.3" }
  s.source_files = 'RMDateSelectionViewController/*'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.framework    = 'CoreGraphics', 'QuartzCore'
end
