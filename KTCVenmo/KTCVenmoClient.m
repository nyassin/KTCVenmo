//
//  PicmentsVenmoClient.m
//  Picments
//
//  Created by Adam Reis on 6/10/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Venmo Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "KTCVenmoClient.h"

static VenmoClient *venmoClient;

@implementation KTCVenmoClient

+ (VenmoClient *)sharedVenmoClient {
//    if(!venmoClient) venmoClient = [VenmoClient clientWithAppId:@"1288"
//                                                         secret:@"a8Vg5UpucxWQH5VUfdKRcS4UCbrqbPDX"];
   if(!venmoClient) venmoClient = [VenmoClient clientWithAppId:@"1000"
                                                         secret:@"8jVVX8WDs7kESbPgjZWm5xp77RTGTmLA"];
    return venmoClient;
}

@end


