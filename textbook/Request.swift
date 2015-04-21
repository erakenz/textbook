//
//  JWRequest.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class Request {
    
    var request: STHTTPRequest?
    
    func urlPath() -> String {
        return ""
    }
    
    func encoding() -> String {
        return "UTF-8"
    }
    
    func loadWithCompletion(completion:(dict: NSDictionary?, error: NSError?) -> Void) {
        if self.urlPath().lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            completion(dict: nil, error: NSError(domain: "没有URL", code: 1, userInfo: nil));
            return;
        }
        let str = RequestCache.getCachedResponseForPath(self.urlPath())
        if let str = str {
            self.parse(str, withCompletion: completion)
        } else {
            NSLog("JWRequest: load \(self.urlPath())")
            self.request?.cancel()
            self.request = STHTTPRequest(URLString: self.urlPath())
            self.request?.setValue(self.encoding(), forKey: "responseStringEncodingName")
            self.request?.completionBlock = {
                (headers: Dictionary!, body: String!) in
                NSLog("JWRequest: completion \(headers as NSDictionary) \(body)")
                RequestCache.cacheResponse(body, forPath: self.urlPath())
                self.parse(body, withCompletion: completion)
            }
            self.request?.errorBlock = { (error) -> Void in
                if error.code == 1 {
                    return
                }
                completion(dict: nil, error: error)
            }
            self.request?.startAsynchronous()
        }
    }
    
    func parse(body: String, withCompletion completion:(dict: NSDictionary?, error: NSError?) -> Void) {
        var error: NSError?
        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, options: NSJSONReadingOptions(), error: &error)
        if let dict = jsonObject as? NSDictionary {
            completion(dict: dict, error: nil)
        } else {
            completion(dict: nil, error: NSError(domain: "JSON解析出错", code: 1, userInfo: nil))
        }
    }
}