# MachtSpass
This is the repository for the MachtSpaß iOS App of our Team at [hackaTUM](https://hack.tum.de). hackaTUM was the first hackathon of the Technical University of Munich, with 252 people involved, 15 sponsors and 50 projects.

Our team chose to hack for the Media-Saturn challenge. The challenge was to improve the user experience of customers in their stores by having more fun. Ideally by gamification.

The following description of our project is mostly the description we submitted on devpost.com together with the project at the deadline of the hackathon. [MachtSpass project on devpost.com](https://devpost.com/software/machtspass)

## Inspiration
Media-Saturn electronic stores have a huge amount of devices to sell and they mostly sell them the analog way in the stores. The customer is often overwhelmed by the big selection that is offered. If he had some positive opinions from other users which already buyed this device, he more likely will buy the product too. The store benefits from the customer relationship and the usage data. The gamification approach to collect *Spassbucks* acts as a motivator to review the products.

## What it does
"MachtSpass" is an interactive app that gives the user the ability to get detailed information and personal opinions about products he is interested in. After scanning a QR code on the price label of the product, the customer can ask "Macht dieses Produkt Spaß?" with the push of one button. This will trigger push notifications for all customers who also installed the app and already bought the product.

The asked customers can answer within one second with "Macht Spaß" (good) or "Macht keinen Spaß" (bad) (Simple and Quick Reply).

By replying to those questions the responding user can earn *SpassBucks* to get discounts and other advantages.

## How we built it
The Proof of Concept consists of an iOS application written in Swift 3.0 using functional reactive programming, which connects to a hosted backend via REST-API. The notification distribution logic is also triggered by posting questions to the REST-API. We are using the new rich push notifications introduced with iOS 10 to reply to the user.

## Challenges we ran into
Preparation and configuration of the Azure Services was quite hard, especially for the push notifications, because their documentation is utterly outdated and various sections display different answers to the same problem. Apart from that, managing the communication routes was challenging too. And time of course, as all of this had to be implemented in just two days 😉

## What's next for MachtSpass
More direct interaction between the customers themselves, e.g. a question-answer chat. Feature Comparison between devices.

----

# Running the app
You'll need a few things before you can start the app. First of all, you'll need [Xcode 8](https://developer.apple.com/xcode/download/), since the App is written in Swift 3.0.1 and targeting iOS 10 devices. Additionally, you need [carthage](https://github.com/Carthage/Carthage), to build the dependencies.

To build the dependencies, you need to run 
```
carthage bootstrap --platform iOS --no-use-binaries
```

Afterwards, you'll probably need to select a Development Team in the Xcode project, since our app uses real push notifications triggered by a node.js backend.

----
## Credits
Icons were created from the following assets:
* [Home](https://thenounproject.com/icon/681787/) by [Jamison Wieser](https://thenounproject.com/jamison/) from the [Noun Project](https://thenounproject.com). Licensed under CCv3
* [QR Code](https://thenounproject.com/icon/78107/) by [Rohith M S](https://thenounproject.com/rohithdezinr/) from the [Noun Project](https://thenounproject.com). Licensed under CCv3
