//
//  FAHelpers.h
//  Food
//
//  Created by Timothy Desir on 3/17/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//


// UIKit helpers
#import "UIColor+Helpers.h"
#import "UINavigationBarInteractivePopGesture.h"
#import "UINavigationControllerObserver.h"

// other helpers
#import "FALocationManager.h"
#import "NSString+Score.h"
#import "NSString+Helpers.h"
#import "UIImage+Places_GMSPlaces.h"

#define DIV_HEIGHT 1.0f / [[UIScreen mainScreen] scale]
#define TABLE_HORI_PADDING 18
#define OPEN_SFURL(URL) [[NSNotificationCenter defaultCenter] postNotificationName:@"open_url_sfsafariviewcontroller" object:@{@"url": URL}]

#define TABLE_CONTENT_INSET_TOP ([self statusBarAccessoryView].frame.size.height)

#define PLACEHOLDER_ORANGE [UIColor colorWithHexString:@"#ef6c54"]
#define PLACEHOLDER_GOLD [UIColor colorWithHexString:@"#fbbc43"]
#define PLACEHOLDER_LIGHT_GREEN [UIColor colorWithHexString:@"#95d063"]
#define PLACEHOLDER_LIGHT_BLUE [UIColor colorWithHexString:@"#20c3e1"]
#define PLACEHOLDER_BLUE_FADE [UIColor colorWithHexString:@"5775cd"]
#define PLACEHOLDER_FOREST_GREEN [UIColor colorWithHexString:@"3fb34f"]
#define PLACEHOLDER_FAV_RED [UIColor colorWithHexString:@"#fc4758"]
#define PLACEHOLDER_DEFAULT_GREY [UIColor colorWithHexString:@"#989898"]
