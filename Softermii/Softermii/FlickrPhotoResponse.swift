//
//  FlickrPhotoResponse.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import ObjectMapper

class FlickrPhotoResponse :Mappable {
    var id: String?
    var title: String?
    var farm: Int?
    var secret: String?
    var server: String?
    var owner: String?
    var isFriend: Bool?
    var image:UIImage?
    
    var imagePath:String? {
        get {
            guard let farm = farm, let server = server, let id = id, let secret = secret else { return nil }

            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        farm <- map["farm"]
        secret <- map["secret"]
        server <- map["server"]
        owner <- map["owner"]
        isFriend <- map["isfriend"]
    }

    required init?(map: Map) {
        
    }

}

