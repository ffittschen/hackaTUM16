# MachtSpaß
📱 Repository for the MachtSpaß iOS App of our Team at hackaTUM

## Running the app

You'll need a few things before you can start the app. First of all, you'll need [Xcode 8](https://developer.apple.com/xcode/download/), since the App is written in Swift 3.0.1 and targeting iOS 10 devices. Additionally, you need `carthage`, to build the dependencies.

To build the dependencies, you need to run 
```
carthage bootstrap --platform iOS --no-use-binaries
```

Afterwards, you'll probably need to select a Development Team in the Xcode project, since our app uses real push notifications triggered by the Azure Notification Hub.

