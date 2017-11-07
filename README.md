# NetScaleNow

[![CI Status](http://img.shields.io/travis/jstubenrauch/NetScaleNow.svg?style=flat)](https://travis-ci.org/netscalenow/ios_sdk)
[![Version](https://img.shields.io/cocoapods/v/NetScaleNow.svg?style=flat)](http://cocoapods.org/pods/NetScaleNow)
[![License](https://img.shields.io/cocoapods/l/NetScaleNow.svg?style=flat)](http://cocoapods.org/pods/NetScaleNow)
[![Platform](https://img.shields.io/cocoapods/p/NetScaleNow.svg?style=flat)](http://cocoapods.org/pods/NetScaleNow)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NetScaleNow is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NetScaleNow"
```

## Verwendung
Als erstes muss der SDK-Key und der SDK-Token gesetzt werden. Dies kann beispielsweise in der AppDelegate erfolgen.

```
func application(_ application: UIApplication, 
didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

Config.apiKey = "ios-sdk-123456789"
Config.apiSecret = "123456789"

return true
}
```

An dem Punkt an dem dann Gutscheinauswahl angezeigt werden soll, wird dann nur eine Zeile benötigt.

```
CampaignManager.showCampaigns()
```

## Konfiguration
Die Konfiguration erfolgt über das Config struct. Hier kann der SDK-Key und das SDK-Token gesetzt werden.

```
Config.apiKey = "ios-sdk-123456789"
Config.apiSecret = "123456789"
```

## Metadaten
Beim Anzeigen der Gutscheinliste können optional Metadaten mitgegeben werden. Insbesondere die Email Adresse des Nutzers ist hier anzugeben, damit dieser diese nicht erneut eingeben muss, um einen Gutschein zu erhalten.

```
let metadata = Metadata(email: "user.mail@foobar.com")
metadata.gender = .male // .female
metadata.zipCode = "76133"
metadata.firstName = "Daniel"
metadata.lastName = "Müller"
metadata.birthday = Date()

CampaignManager.showCampaigns(metadata: metadata)
```

## Callback
Optional kann ein Callback übergeben werden, um über die Beendigung der Gutscheinauswahl informiert zu werden.

```
CampaignManager.showCampaigns(metadata: metadata) {
// Voucher selection has been dismissed 
}
```

## Author

NetScaleNow, technik@netscalenow.com

## License

NetScaleNow is available under the MIT license. See the LICENSE file for more info.
