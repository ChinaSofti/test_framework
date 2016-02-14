//
//  SVNetworkConnectionDelegate.h
//  SPUIView
//
//  Created by Rain on 2/14/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

@protocol SVNetworkConnectionDelegate <NSObject>

@required
- (void)networkConnectStatusChange:(BOOL)connectionAvailable

@end