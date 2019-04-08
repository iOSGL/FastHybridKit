//
//  WebModel.h
//  iOSDemo
//
//  Created by genglei on 2019/4/4.
//  Copyright © 2019年 genglei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* category;
@property (nonatomic, copy) NSString* webUrl;
@property (nonatomic, copy) NSString* htmlUrl;
@property (nonatomic, strong) id parameter;
@property (nonatomic , copy) NSString *registerActionName;
@property (nonatomic , copy) NSString *callHandleActionName;
@property (nonatomic , assign) BOOL hideNavigationBar;
@property (nonatomic , copy) NSString *modelType;

@end


