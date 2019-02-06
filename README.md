## places-ios
![PlacesHeader](https://raw.githubusercontent.com/Timstarockz/places-ios/master/places-git-header.png)
# The Places Gadget for iOS

Here is a little Objective-C app concept I made to test out the GoogleMap and Yelp APIs and practice some design techniques. The UI was built with Texture (formally AsyncDisplayKit).

#####*Don't expect a super polished and complete app here.* 
I made this to run into very specific problems so I could practice my way around them. I did get to make some really fun stuff though! Please check the "Notable things" section for some good little tidbits.


## Setup

just start up the good ol' `pod install` to get started

## Notable things:

There are a number of wild things going on in this experiment of mine. As I was just looking through some of the code, I thought it'd be a good idea to maybe make note of all my favorite parts and some unfinished symphonies of code.


#Google Maps/Places and Yelp API:

You will probably have to supply your own API keys for Google Maps and Google Places. I deleted the apps a while ago on the Google Developers Console. The Yelp API should work fine with the key that's in the code.

#OnboardingKit:

This will eventually be it's own project with its own repo + pod.
OnboardingKit is a framework built with Texture (formally AsyncDisplayKit) to make stock onboarding screens to inform users and collect data.

It has things like `OKInfoItem` to represent a bulletpoint of information on a `OKOnboardingPage`:

```
@interface OKInfoItem : NSObject

@property (nonatomic) UIImage *icon;
@property (nonatomic) UIColor *iconColor;

@property (nonatomic) NSAttributedString *title;
@property (nonatomic) NSAttributedString *subtitle;
@property (nonatomic) NSAttributedString *body;

@end
```
```
@interface OKOnboardingPage : ASDisplayNode

- (NSAttributedString * _Nonnull)title;
- (nullable NSArray<OKInfoItem *> *)infoItems;
- (NSString * _Nonnull)nextButtonTitle;

- (NSArray<OKAnimation *> * _Nonnull)introSequence;
- (NSArray<OKAnimation *> * _Nonnull)outroSequence;


// Default Fonts:
- (NSDictionary * _Nonnull)titleFontAttributesWithColor:(UIColor * _Nonnull)color;

- (NSDictionary * _Nonnull)infoTitleFontAttributes;

- (NSDictionary * _Nonnull)infoSubtitleFontAttributes;

- (NSDictionary * _Nonnull)infoBodyFontAttributes;

@end
``` 

![OKPage](https://i.imgur.com/BCCMT2A.png)

You may have noticed there is a class named `OKAnimation`. The vision for this class was to be able to have `OKOnboardingPage`'s have a sequence of intro animations for when it appears on the screen and a sequence of animations for when navigating to another page.

`OKOnboardingPage` has class properties named `introSequence` and `outroSequence`.

In your .m, you would define your animations like this:

```
// Onboarding_WelcomePage.m

#pragma mark = Animation Sequences

- (NSArray<OKAnimation *> * _Nonnull)introSequence {
    return @[[OKAnimation delay:5],
             [OKAnimation fadeIn:@[@"title", @"find", @"favs", @"lists"] duration:1.2 delay:1.0 postDelay:0.5],
             [OKAnimation fadeIn:@[@"next_button"] duration: 0.5 delay:1.0 postDelay:0.0]];
}

- (NSArray<OKAnimation *> * _Nonnull)outroSequence {
    return @[[OKAnimation delay:0.4],
             [OKAnimation fadeOut:@[@"title", @"find", @"favs", @"lists"] duration:1.2 delay:1.0 postDelay:0.5],
             [OKAnimation fadeOut:@[@"next_button"] duration: 0.5 delay:1.0 postDelay:0.0]];
}
```

The animation manager would then run the `OKAnimation`'s in order from 0-n.

*`postDelay` refers to the immediate delay after the animation it was defined in.

*`@"title", @"find", @"favs", @"lists"` refers to the variable names defined in the the user defined `infoItems` in their subclass of `OKOnboardingPage`

#FAKit:

*FA = "FoodApp" the original name for this app*

*"Fakit, I'll make a custom UI Kit."*

This is a custom UIKit I wrote that I completely forgot about.

It features some interesting components that are all designed to function similar to Apple's UIKit so the learning curve for new devs is small. 


#FAStatusBarTray + FANavBar

`FAStatusBarTray` is a view container that lives right under the `UIStatusBar`. In this app, you'll see that it can transition between a search bar (`FASearchBar`), navigation bar (`FANavBar`), a custom view (`UIView`), or it can be minimized.

It's very simple:

```
@interface FAStatusBarTray : UIVisualEffectView

- (void)showTrayWithView:(UIView *)view;
- (void)dismissTray;

@end
```

A subclass of `FAViewController` will define a class property named `statusBarAccessoryView`:

```
// FindViewController.m

- (UIView *)statusBarAccessoryView {
    return searchBar;
}
```

Yeah... that means every view controller needs a `FANavBar` needs to define one :P

```
// PlaceViewController.m

// init nav bar
navBar = [[FANavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
[navBar setShowBackButton:true];
//
...

- (UIView *)statusBarAccessoryView {
    return navBar;
}
```

It's kind of annoying but I'm sure a healthy refactor in some areas could fix this.

#FATabbedToolbar 

This view acts kind of like a `UITabBar` and `UIToolbar` at the same time.

The code in that file is kind of insane and was made just as a proof of concept. but hey! it works!

It's model was inspired by a Binary Tree except `FABarItem`'s only have a `rightItem` to represent the right toolbar item that only displays when the `FATabbedToolbar` is in `FATTToolbarMode`

A subclass of `FAViewController` will define:

```
// FindViewController.m

- (FABarItem *)tabBarItem {
    FABarItem *root = [[FABarItem alloc] init];
    root.title = @"Find Places";
    root.icon = [UIImage imageNamed:@"search_con2"];
    root.backgroundColor = PLACEHOLDER_LIGHT_BLUE;//@"#91e467"];
    
    FABarItem *mapButton = [[FABarItem alloc] init];
    mapButton.title = @"Toggle Map View";
    mapButton.icon = [UIImage imageNamed:@"map_con3"];
    mapButton.backgroundColor = [UIColor darkGrayColor];
    root.rightItem = mapButton;
    
    return root;
}
```

#FANavigationController

This class acts as a wrapper for `UINavigationController` that makes it easier for me to plug and play with the other components. A lot of the code in ```FANavigationController.m``` is really just code to highjack certain information to feed back to the rest of `FAKit` so it can work properly. BUT it also acts as a "Places" themed `UINavigationController`.

What does that mean?

`FANavigationController` behaves just like a normal `UINavigationController` but with a built in `FAStatusBarTray` and `FANavBar` that just looks for the root view controllers `FANavigationItem *navItem`

```
// ListsViewController.m

- (void)newList {
    CreateListViewController *create = [[CreateListViewController alloc] initWithNibName:nil bundle:nil];
    FANavigationController *createN = [[FANavigationController alloc] initWithRootViewController:create];
    createN.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.container presentViewController:createN animated:true completion:nil];
}
```

This was my model presentation solution to the problem I stated earlier about having to define a `FANavBar` for every `FAViewController` subclass that needs one.

#FAMapContainerViewController

`FAMapContainerViewController` is an esoteric class built to fit the design spec. It acts as the root for the entire UI. Its subviews include:

• `GMSMapView` // `MKMapView`

• `UINavigationController`

• `FAStatusBarTray`

• `FATabbedToolbar`

• `FALocationButton`


You can see how it is initialized in ```AppDelegate.m```:

```
- (void)setupViewControllers {
    self.controller = [[FAMapContainerViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.controller;
    
    FindViewController *search = [[FindViewController alloc] initWithNibName:nil bundle:nil];
    FavoritesViewController *favorites = [[FavoritesViewController alloc] initWithNibName:nil bundle:nil];
    ListsViewController *lists = [[ListsViewController alloc] initWithNibName:nil bundle:nil];
    //
    [self.controller setViewControllers:@[search, favorites, lists]];
}
```

#NSString+Score:

So, `Places` uses `Realm` database to cache `Place` info but I realized that I wouldn't want to save this info for too long just incase the information changed often. The app also gets `Place` info from Google and Yelp and there can be discrepancies between some of their information.

Here's the run down:

• When using Google Maps and tapping on POIs, it will return very basic info: `place_id`, `name`, `longitude`, `latitude`. Info that needs to be passed to the GOOGLE PLACES API THAT ALSO COSTS MONEY AT SCALE. So the goal was to not and spend as MUCH money that could be spent using it the normal way.

• When `placeInfo` gets passed into `PlaceViewController`, It will first look up the place using the Yelp API (because it's free :P)

• Like I mentioned earlier though, the data between Yelp and Google can be a little different. If the Yelp API fails or it can't find the write location, it will fail safe to looking up the Google Place info.

• Scoring comes in when checking the Google Place `name` against the Yelp place model`.name`

It won't call Google Maps API unless it absolutely has to. Saving me money!

[NSString + Score](https://github.com/thetron/StringScore)

#FALocationManager:

I needed a location manager that wasn't a pain to setup. It has a very simple interface and can be used to *retrieve* 1 "screenshot" of your location or to *monitor* location data in real time.

```
typedef NS_ENUM(NSUInteger, FALocationTypes) {
    // Authorization States
    FALocationAuthorizationAlways,
    FALocationAuthorizationWhenInUse,
    FALocationAuthorizationBlocked,
    
    // Request States
    FALocationRequestSuccess,
    FALocationRequestStopped,
    FALocationRequestFailed,
    
    // Actions
    FALocationRetrieveLocation,
    FALocationMoniterLocation,
};


typedef void(^FALocationAuthBlock)(FALocationTypes atype, CLAuthorizationStatus status, NSError *error);
typedef void(^FALocationRequestBlock)(FALocationTypes rtype, CLLocation *location, NSError *error);


@interface FALocationManager : NSObject <CLLocationManagerDelegate>

- (void)enableLocationServices:(FALocationTypes)type callback:(FALocationAuthBlock)block; // calls back on main thread

- (void)locationRequest:(FALocationTypes)type callback:(FALocationRequestBlock)block; // calls back on main thread -v
- (void)locationRequest:(FALocationTypes)type withDistanceFilter:(double)distance callback:(FALocationRequestBlock)block;

- (void)stopMoniteringUpdates;

@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic) CLLocationManager *manager;

@property (nonatomic, readonly) BOOL active; // if the manager is currently updating / or trying to update location data
@property (nonatomic, readonly) BOOL authorized; // if the manager is already authorized to receive some kind of location updates

@end
```

Usage:

```
// FindViewController.m

// enable location services
[locationManager enableLocationServices:FALocationAuthorizationWhenInUse callback:^(FALocationTypes type, CLAuthorizationStatus status, NSError *error) {
        if (type == (FALocationAuthorizationAlways || FALocationAuthorizationWhenInUse)) {
            
            // moniter location. the block will be fired until instructed to stop monitering
            [self->locationManager locationRequest:FALocationMoniterLocation withDistanceFilter:28 callback:^(FALocationTypes rtype, CLLocation *location, NSError *error) {
                if (rtype == FALocationRequestSuccess) {
                    NSLog(@"%s - Monitering: Retrieved Location: %@", __PRETTY_FUNCTION__, location.description);
                    [self getNearbyPlaces];
                } else if (rtype == FALocationRequestFailed) {
                    NSLog(@"%s - Monitering: Failed Retrieved Location: %@", __PRETTY_FUNCTION__, location.description);
                }
            }];
            
        } else if (type == FALocationAuthorizationBlocked) {
            NSLog(@"%s - Location Services Blocked", __PRETTY_FUNCTION__);
        }
}];
```

When the location request isEqual to `FALocationMoniterLocation`, you can supply a distance filter which represents the amount of distance you must move for the location to be updated. That way the list of Places Around You doesn't update evert few steps but instead every few blocks.

#PlaceHoursNode.m:

This was a fun little UI module to craft. Learned a lot about layout when making this and the code is interesting. Check it out! Fix it please!! (It's pictured in the middle iPhone in the header image)

#Private methods for fun:

It had been a while since I called private methods so I decided to use them in `FANavigationController` and `FAMapContainerViewController`. I also think they look nice:

```
// FANavigationController.m

// since the incoming view controller is being pushed, private set the presentation origin
    SEL selector = NSSelectorFromString(@"_setPresentationOrigin:");
    if ([(FAViewController *)viewController respondsToSelector:selector]) {
        if (_navigationController.viewControllers.count < 2) {
            if (self.presentationOrigin == FAViewControllerPresentationOriginPresented) {
                ((void (*)(id, SEL, FAViewControllerPresentationOrigin))[(FAViewController *)viewController methodForSelector:selector])((FAViewController *)viewController, selector, FAViewControllerPresentationOriginPresented);
            } else {
                ((void (*)(id, SEL, FAViewControllerPresentationOrigin))[(FAViewController *)viewController methodForSelector:selector])((FAViewController *)viewController, selector, FAViewControllerPresentationOriginPushed);
            }
        } else {
            ((void (*)(id, SEL, FAViewControllerPresentationOrigin))[(FAViewController *)viewController methodForSelector:selector])((FAViewController *)viewController, selector, FAViewControllerPresentationOriginPushed);
        }
    }
    
// private set nav controller for incoming view
__weak FANavigationController *wself = self;
SEL selectorSetContianer = NSSelectorFromString(@"_setNavigationController:");
if ([(FAViewController *)viewController respondsToSelector:selectorSetContianer]) {
      ((void (*)(id, SEL, FANavigationController *))[(FAViewController *)viewController methodForSelector:selectorSetContianer])((FAViewController *)viewController, selectorSetContianer, wself);
}
```

#Design

This repo includes a .psd named `Food.psd.zip`. It's kind of a big file because Photoshop is just like this sometimes. It includes all the designs I had planned for this app. Have fun!