//
//  API.swift
//  bestofmasters
//
//  Created by Eugene Kuropatenko on 12/19/16.
//  Copyright © 2016 bestofmasters. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import ObjectMapper

typealias succesResponse = (_ request:DataResponse<Any>, _ response:[String:Any]) -> ()
typealias failureResponse = (_ request:DataResponse<Any>?, _ error:NSError) -> ()
typealias voidCloser = () -> ()

fileprivate let flickrKey = "dace9fbbca561e5905cce4c5de642436"
fileprivate let flickrSecret = "26d9311d3efe7021"

class API {
    static let baseURLString = "https://api.flickr.com/services"
    static var session: String?
    
    
    @discardableResult
    static func performRequest(_ path:String, method:HTTPMethod, parameters:[String: Any]?, sender:UIViewController! , succes: succesResponse?, failure: failureResponse?) -> URLSessionTask? {
        var params = parameters ?? [:]
        params["api_key"] = flickrKey
        params["format"] = "json"
        params["nojsoncallback"] = "1"
        return Alamofire.request("\(API.baseURLString)/\(path)", method:method, parameters: params).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { (response) in
            handleJSONResponse(response, sender: sender, succes: succes, failure: failure)
        }.task
    }
    
    static func handleJSONResponse(_ response:DataResponse<Any>,sender:UIViewController! , succes: succesResponse?, failure: failureResponse?)  {
        switch response.result {
        case .success:
            if let responseJSON = response.result.value as? [String: Any] {
                succes?(response, responseJSON)
                return
            }
            failure?(response, NSError(domain: "", code: -1, userInfo: nil ))
        case .failure(let error):
//            print(error)
            failure?(response, error as NSError)
            if let error = error as NSError! , sender != nil {
                switch error.code {//NSURLErrorCannotConnectToHost
                case NSURLErrorCannotLoadFromNetwork ... NSURLErrorBadURL:
                    print(error)
                    sender.showPopupWithTitle(NSLocalizedString("Server connection error", comment: ""),
                                              text: NSLocalizedString("The operation could not be performed. Try to change you location or Internet connection.", comment: ""),
                                              button: NSLocalizedString("OK", comment: ""))
                default :
                    return
                }
            }
        }
    }
    
    static func performRequest(_ path:String, method:HTTPMethod, parameters:[String: Any], succes: succesResponse?, failure: failureResponse?) -> URLSessionTask? {
        return performRequest(path, method: method, parameters: parameters, sender: nil, succes: succes, failure: failure)
    }
    
}

extension API {
    static func gettingRequestToken(sender:UIViewController, success:voidCloser?, failure:voidCloser?) {
        
        let oauthswift = OAuth1Swift(
            consumerKey:    flickrKey,
            consumerSecret: flickrSecret,
            requestTokenUrl: "\(baseURLString)/oauth/request_token",
            authorizeUrl:    "\(baseURLString)/oauth/authorize",
            accessTokenUrl:  "\(baseURLString)/oauth/access_token"
        )
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: sender, oauthSwift: oauthswift)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "softermii://oauth-callback/flickr")!,
            success: { credential, response, parameters in
                Preferences.saveUser(parameters)
        },
            failure: { error in
                print(error.description)
        }
        )
    }
    
    @discardableResult
    static func searchPhoto(_ text:String, page:Int ,sender:UIViewController?, success:((_ photos:[FlickrPhotoResponse], _ total:Int) -> ())?, failure:voidCloser?)-> URLSessionTask? {
        var params:[String: Any] = ["method":"flickr.photos.search","page":page,"per_page":50]
        if text.characters.count == 0 {
            params["method"] = "flickr.photos.getRecent"
        } else {
            params["text"] = text
        }
        return performRequest("rest",  method: .get, parameters:params , sender:sender, succes: { (request, response) in
            guard let photos = response["photos"] as? [String : Any] else {
                failure?()
                return
            }
            
            guard let photoArray = photos["photo"] as? [[String : Any]] else {
                failure?()
                return
            }
            
            guard let photoArr = Mapper<FlickrPhotoResponse>().mapArray(JSONArray: photoArray) else {
                failure?()
                return
            }
            success?(photoArr, photos["total"] as? Int ?? Int(photos["total"] as! String)!)
        }) { (request, error) in
//            print(error)
            failure?()
        }
    }
    
}
