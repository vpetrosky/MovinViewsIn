
Pod::Spec.new do |s|

 
  s.name         = "MovinViewsIn"
  s.version      = "1.0.0"
  s.summary      = "MovinViewsIn is an animation library that adds seamless transitions to your iOS app, giving your product a polished feel."


  s.description  = <<-DESC
  "Apple gives us many out of the box options for transitioning from one viewController to the next. We can push on, present modally, show popovers and more. But what if you want to add an extra layer of polish to your transitions? MovinViewsIn provides custom animated transitions between your views when you don't have time to write all that custom code. Want a transition like the one you see in Apple's Photos app? Check out our first available transition by conforming to the ImageTransitionable protocol."
                   DESC

  s.homepage     = "https://github.com/vpetrosky/MovinViewsIn"


  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Vanessa Petrosky" => "vanessa.petrosky@gmail.com" }


  s.platform     = :ios, "12.0"


  s.source       = { :git => "https://github.com/vpetrosky/MovinViewsIn.git", :tag => "#{s.version}" }

  
  s.source_files = "MovinViewsIn/**/*.{swift}"

 
  s.resources = "MovinViewsIn/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"


  s.framework = "UIKit"


  s.requires_arc = true
  s.swift_version = "4.2"

end
