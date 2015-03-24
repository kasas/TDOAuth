//
//  TDOAuthTest.m
//  TDOAuthTest
//
//  Created by Bob Fitterman on 3/22/15.
//
//

#import <XCTest/XCTest.h>
#import "TDOAuthTest.h"

@implementation TDOAuthTest

- (void)setUp
{
    [super setUp];
    [TDOAuth enableStaticValuesForAutomatedTests];
    getRequest = [TDOAuth URLRequestForPath:@"/service"
                              GETParameters:@{@"foo": @"bar"}
                                       host:@"api.example.com"
                                consumerKey:@"abcd"
                             consumerSecret:@"efgh"
                                accessToken:@"ijkl"
                                tokenSecret:@"mnop"];
    postRequest = [TDOAuth URLRequestForPath:@"/service"
                              POSTParameters:@{@"foo": @"bar"}
                                        host:@"api.example.com"
                                 consumerKey:@"abcd"
                              consumerSecret:@"efgh"
                                 accessToken:@"ijkl"
                                 tokenSecret:@"mnop"];

}

- (void)tearDown
{
    getRequest = nil;
    [super tearDown];
}

- (void)testGetMethod
{
    XCTAssert([[getRequest HTTPMethod] isEqualToString:@"GET"],
              "method (verb) expected to be GET");
}

- (void)testGetBody
{
    NSData *body = [getRequest HTTPBody];
    //NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    XCTAssertNil(body,
                 "body expected to be nil");
}

- (void)testGetUrl
{
    NSString *url = [[getRequest URL] absoluteString];
    XCTAssert([url isEqualToString:@"http://api.example.com/service?foo=bar"],
              "url does not match expected value");

    NSString *contentType = [getRequest valueForHTTPHeaderField: @"Content-Type"];
    XCTAssertNil(contentType,
              @"Content-Type was present when not expected)");
    
    NSString *contentLength = [getRequest valueForHTTPHeaderField: @"Content-Length"];
    XCTAssertNil(contentLength,
              @"Content-Length was set when not expected)");
    
}

- (void)testGetUrlWithHttps
{
    
    NSURLRequest *httpsRequest = [TDOAuth URLRequestForPath: @"/service"
                                              GETParameters:@{@"foo": @"bar"}
                                                     scheme:@"https"
                                                       host:@"api.example.com"
                                                consumerKey:@"abcd"
                                             consumerSecret:@"efgh"
                                                accessToken:@"ijkl"
                                                tokenSecret:@"mnop"];
    NSString *url = [[httpsRequest URL] absoluteString];
    XCTAssert([url isEqualToString:@"https://api.example.com/service?foo=bar"],
              @"url does not match expected value");


}
- (void)testGetHeaderAuthField
{
    NSString *authHeader = [getRequest valueForHTTPHeaderField:@"Authorization"];
    NSString *expectedHeader = @"OAuth oauth_token=\"ijkl\", "\
                                "oauth_nonce=\"static-nonce-for-testing\", "\
                                "oauth_signature_method=\"HMAC-SHA1\", oauth_consumer_key=\"abcd\", "\
                                "oauth_timestamp=\"1456789012\", oauth_version=\"1.0\", "\
                                "oauth_signature=\"O4hspbDTqHlLdqfXxR0jSly9bkU%3D\"";
    XCTAssert([authHeader isEqualToString:expectedHeader],
              @"Expected header value does does not match");
}

- (void)testPostMethod
{
    XCTAssert([[postRequest HTTPMethod] isEqualToString:@"POST"],
              "method (verb) expected to be POST");
}
- (void)testPostBody
{
    NSData *body = [postRequest HTTPBody];
    NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    XCTAssert([bodyString isEqualToString:@"foo=bar"],
              "body expected to be structured");
}

- (void)testPostUrl
{
    NSString *url = [[postRequest URL] absoluteString];
    XCTAssert([url isEqualToString:@"https://api.example.com/service"],
              "url does not match expected value");
    
    NSString *contentType = [postRequest valueForHTTPHeaderField: @"Content-Type"];
    XCTAssert([contentType isEqualToString:@"application/x-www-form-urlencoded"],
              @"Content-Type is not expected value)");

    NSString *contentLength = [postRequest valueForHTTPHeaderField: @"Content-Length"];
    XCTAssert([contentLength isEqualToString:@"7"],
              @"Content-Length is not expected value)");

}
- (void)testPostHeaderAuthField
{
    NSString *authHeader = [postRequest valueForHTTPHeaderField:@"Authorization"];
    NSString *expectedHeader = @"OAuth oauth_token=\"ijkl\", "\
    "oauth_nonce=\"static-nonce-for-testing\", "\
    "oauth_signature_method=\"HMAC-SHA1\", oauth_consumer_key=\"abcd\", "\
    "oauth_timestamp=\"1456789012\", oauth_version=\"1.0\", "\
    "oauth_signature=\"pr%2ForWfyT9CsKTGW85AwjHmFjd8%3D\"";
    XCTAssert([authHeader isEqualToString:expectedHeader],
              @"Expected header value does does not match");
}
@end
