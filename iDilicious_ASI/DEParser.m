//
//  DEParser.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-1.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEParser.h"
#import "TouchXML.h"
#import "DEPost.h"
#import "DEBundle.h"
#import "DETag.h"
#import "DEStat.h"

@implementation DEParser

+ (NSString *)parseResult:(NSString *)xmlString
{
    if (0 == [xmlString length])
        return nil;
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options: 0 error: nil];
    NSArray *root = [doc nodesForXPath:@"//result" error:nil];//根结点
    CXMLElement *Link = [root lastObject];
    NSString *code = [[Link attributeForName:@"code"] stringValue];
    
    if (!code) {
        code = [Link stringValue];
    }
    return code;
}

+ (NSMutableArray *)parsePosts:(NSString *)xmlString
{
    if (0 == [xmlString length])
        return nil;
    NSMutableArray* items = [[[NSMutableArray alloc] init] autorelease];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options: 0 error: nil];
    NSArray *resultNodes = nil;
    resultNodes = [doc nodesForXPath:@"//posts" error:nil];//根结点
    if ([resultNodes count]) {
        CXMLElement *rootElement = [resultNodes lastObject];
        if (rootElement) {
            NSArray* tagElement = [rootElement elementsForName:@"post"];
            for(CXMLElement* _tagElement in tagElement)
            {
                DEPost *post = [[DEPost alloc] init];
                post.description = [[_tagElement attributeForName:@"description"] stringValue];
                post.href = [[_tagElement attributeForName:@"href"] stringValue];
                post.extended = [[_tagElement attributeForName:@"extended"] stringValue];
                post.time = [[_tagElement attributeForName:@"time"] stringValue];
                post.tag = [[_tagElement attributeForName:@"tag"] stringValue];
                post.isPrivate = [[_tagElement attributeForName:@"private"] stringValue];
                post.isShared = [[_tagElement attributeForName:@"shared"] stringValue];
                post.hash = [[_tagElement attributeForName:@"hash"] stringValue];
                [items addObject:post];
                [post release];
            }
        }
    }
    return items;
}

+ (NSMutableArray *)parseBundles:(NSString *)xmlString
{
    if (0 == [xmlString length])
        return nil;
    
    NSMutableArray* items = [[[NSMutableArray alloc] init] autorelease];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options: 0 error: nil];
    NSArray *resultNodes = nil;
    resultNodes = [doc nodesForXPath:@"//bundles" error:nil];//根结点
    if ([resultNodes count]) {
        CXMLElement *rootElement = [resultNodes lastObject];
        if (rootElement) {
            NSArray* tagElement = [rootElement elementsForName:@"bundle"];
            for(CXMLElement* _tagElement in tagElement)
            {
                DEBundle *bundle = [[DEBundle alloc] init];
                bundle.bundle = [[_tagElement attributeForName:@"name"] stringValue];
                bundle.tags = [[_tagElement attributeForName:@"tags"] stringValue];
                
                [items addObject:bundle];
                [bundle release];
            }
        }
    }
    return items;
}

+ (NSMutableArray *)parseTags:(NSString *)xmlString
{
    if (0 == [xmlString length])
        return nil;
    
    NSMutableArray* items = [[[NSMutableArray alloc] init] autorelease];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options: 0 error: nil];
    NSArray *resultNodes = nil;
    resultNodes = [doc nodesForXPath:@"//tags" error:nil];//根结点
    if ([resultNodes count]) {
        CXMLElement *rootElement = [resultNodes lastObject];
        if (rootElement) {
            NSArray* tagElement = [rootElement elementsForName:@"tag"];
            for(CXMLElement* _tagElement in tagElement)
            {
                DETag *tag = [[DETag alloc] init];
                tag.tag = [[_tagElement attributeForName:@"tag"] stringValue];
                tag.count = [[_tagElement attributeForName:@"count"] stringValue];
                
                [items addObject:tag];
                [tag release];
            }
        }
    }
    return items;
}

+ (NSMutableArray *)parseStats:(NSString *)xmlString
{
    if (0 == [xmlString length])
        return nil;
    
    NSMutableArray* items = [[[NSMutableArray alloc] init] autorelease];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:xmlString options: 0 error: nil];
    NSArray *resultNodes = nil;
    resultNodes = [doc nodesForXPath:@"//dates" error:nil];//根结点
    if ([resultNodes count]) {
        CXMLElement *rootElement = [resultNodes lastObject];
        if (rootElement) {
            NSArray* tagElement = [rootElement elementsForName:@"date"];
            for(CXMLElement* _tagElement in tagElement)
            {
                DEStat *stat = [[DEStat alloc] init];
                stat.date = [[_tagElement attributeForName:@"date"] stringValue];
                stat.count = [[_tagElement attributeForName:@"count"] stringValue];
                
                [items addObject:stat];
                [stat release];
            }
        }
    }
    return items;
}
@end
