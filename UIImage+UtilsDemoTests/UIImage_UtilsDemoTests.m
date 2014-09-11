//
//  UIImage_UtilsDemoTests.m
//  UIImage+UtilsDemoTests
//
//  Created by noughts on 2014/09/08.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImage+Utils.h"

@interface UIImage_UtilsDemoTests : XCTestCase

@end

@implementation UIImage_UtilsDemoTests

- (void)setUp{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResize{
	UIImage* img = [UIImage imageNamed:@"cheetah1136.png"];
	
	
	UIImage* resized1_img = [img resizeImageWithScale:0.5];
	XCTAssertTrue( img.size.width/2 == resized1_img.size.width );
	
	UIImage* resized2_img = [img resizeWithLongSideLength:2000];
	NSLog( @"%@", NSStringFromCGSize(resized2_img.size) );
	
	// リサイズしても回転情報は保持されるべき
	UIImage* rotated_img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationRight];
	UIImage* resized3_img = [rotated_img resizeWithLongSideLength:200];
	XCTAssertTrue( resized3_img.imageOrientation == UIImageOrientationRight );
	
	XCTAssert(img, @"");
}

@end
