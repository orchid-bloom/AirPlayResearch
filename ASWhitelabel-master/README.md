# ASWhitelabel

## Usage

For an example see Project/demo.
To run the example project; clone the repo, and run `pod install` from the Project directory first.

**Note:** AppID and AppToken are required. These can be obtained from AirService

Showing ASWhiteLabelActivity within your application with a single venue for your venue alias = "my-venue".

```objective-c
ASWhitelabelViewController *viewController = [[ASWhitelabelViewController alloc] initWithAppID:@"ABC" appToken:@"123" delegate:self];
viewController.venueAlias = @"my-venue";
[self presentViewController:viewController animated:YES completion:nil];
```

Showing ASWhiteLabelActivity within your application for multiple venues within your filter group provided by AirService ie. "Example Pizza Chain" = "EX01"
```objective-c
ASWhitelabelViewController *viewController = [[ASWhitelabelViewController alloc] initWithAppID:@"ABC" appToken:@"123" delegate:self];
viewController.filter = @"EX01";
viewController.brandColor = @"444444";
[self presentViewController:viewController animated:YES completion:nil];
```
The brandColor property is optional and reflects the default app colour on your main venue listing page.
    
When a user is finished using AirService the following delegate will be called
```objective-c
- (void)ASWhitelabelViewControllerDidRequestExit:(ASWhitelabelViewController *)viewController
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
```

If you're having problems try enabling logging to debug any issues.
```objective-c
viewController.loggingEnabled = YES;
``` 

## Installation

ASWhitelabel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "ASWhitelabel"
    
## Author

danielbowden, www.airservice.com

## License

ASWhitelabel is available under the MIT license. See the LICENSE file for more info.

