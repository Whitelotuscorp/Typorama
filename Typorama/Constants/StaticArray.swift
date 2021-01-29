//
//  StaticArray.swift
//  Typorama
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit


let TEXT_Default = "DOUBLE TAP TO EDIT TEXT"//"WE EASILY CAN DO THIS"

let kBGIMAGE_PROJECT = "PROJECT"
let kBGIMAGE_POSTER = "POSTER SIZE"
let kBGIMAGE_PHOTOS = "MY PHOTOS"
let kBGIMAGE_STOCK = "STOCK IMAGES"
let kBGIMAGE_COLORS = "COLORS"

let ARRAY_Category      = [kBGIMAGE_PROJECT, kBGIMAGE_POSTER, kBGIMAGE_PHOTOS, kBGIMAGE_STOCK, kBGIMAGE_COLORS]

let ARRAY_CanvasColors  = [kBGIMAGE_PROJECT, kBGIMAGE_POSTER, kBGIMAGE_PHOTOS, kBGIMAGE_STOCK, kBGIMAGE_COLORS]

let CUSTOME_Size      = "1"
let ORIGINAL_Size     = "ORIGINAL"
let ARRAY_CanvasSize  = [["name":"Original Size", "scale":"", "size":ORIGINAL_Size],
                         ["name":"Digital LCD Portrait", "scale":"1080\nx\n1920", "size":"1080x1920"],
                         ["name":"Digital LCD Landscape", "scale":"1920\nx\n1080", "size":"1920x1080"],
                         ["name":"Digital 6 Sheet Portrait", "scale":"1080\nx\n1920", "size":"1080x1920"],
                         ["name":"Digital 6 Sheet Landscape", "scale":"1920\nx\n1080", "size":"1920x1080"],
                         ["name":"Digital 6 Sheet Portrait", "scale":"4K", "size":"4x5"],
                         ["name":"Digital 6 Sheet Landscape", "scale":"4K", "size":"5x4"],
                         ["name":"Firefly Taxi Top Landscape", "scale":"1920\nx\n1080", "size":"1920x1080"],
                         ["name":"Custom Size", "scale":"", "size":CUSTOME_Size],
                         ["name":"UK Poster Sizes", "scale":"Coming Soon", "size":""],
                         ["name":"USA Poster Sizes", "scale":"Coming Soon", "size":""]]

let ARRAY_Share        = [["name":"Save", "icon":"share-save"],
                          ["name":"Instagram", "icon":"share-instagram"],
                          ["name":"Facebook", "icon":"share-facebook"],
                          ["name":"WhatsApp", "icon":"share-whatsapp"],
                          ["name":"Mail", "icon":"share-mail"],
                          ["name":"Message", "icon":"share-message"],
                          ["name":"Messenger", "icon":"share-fb-messanger"],
                          ["name":"Twitter", "icon":"share-twitter"],
                          ["name":"Other", "icon":"share-more"]]


let kMENUIMAGE_Image = "Image"
let kMENUIMAGE_Overlays = "Overlays"
let kMENUIMAGE_Filters = "Filters"
let kMENUIMAGE_Adjustments = "Adjustments"

let ARRAY_ImageMenu    = [["name":kMENUIMAGE_Image, "icon":"icon_image"],
//                         ["name":kMENUIMAGE_Overlays, "icon":"icon_overlap"],
//                         ["name":kMENUIMAGE_Filters, "icon":"icon_filter"],
                         ["name":kMENUIMAGE_Adjustments, "icon":"icon_adjustment"]]

let ARRAY_ImageMenu2   = ["temp4.png", "temp3.jpg", "temp2.jpg", "temp1.png"]
let ARRAY_Font   = ["Futura-Bold", "Bebas", "Heavy Equipment", "HelveticaNeue-Bold", "Londrina Solid", "Matiz", "Muro"]

let kImageMenu1_Photo = "CHOOSE FROM MY PHOTOS"
let kImageMenu1_Stock = "SEARCH STOCK IMAGES"
let kImageMenu1_Color = "CHOOSE A COLOR"

let ARRAY_ImageMenu1   = [kImageMenu1_Photo, kImageMenu1_Stock, kImageMenu1_Color]
let ARRAY_ImageMenu4   = ["BRIGHTNESS", "EXPOSURE", "CONTRAST", "VIBRANCY", "SATURATION", "VIGNETTE", "BLUR"]

let ARRAY_Color        = [UIColor.black, UIColor.white, UIColor.red, UIColor.green, UIColor.yellow, UIColor.darkGray, UIColor.orange, UIColor.blue, UIColor.brown, UIColor.gray, UIColor.cyan, UIColor.magenta, UIColor.purple, UIColor.black, UIColor.white, UIColor.red, UIColor.green, UIColor.yellow, UIColor.darkGray, UIColor.orange, UIColor.blue, UIColor.brown, UIColor.gray, UIColor.cyan, UIColor.magenta, UIColor.purple]


let ARRAY_ShapeMenu   = ["001.png", "002.png", "003.png", "004.png", "005.png", "006.png", "007.png", "008.png", "009.png", "010.png"]

let ARRAY_Quote         = ["It is not enough that we do our best; sometimes we must do what is required",
                           "I have seen the best of you, and the worst of you, and I choose both",
                           "If I only had three words of advice, they would be Tell the Truth If got three more words I'd add all the time",
                           "Sometimes doing your best is not good enough Sometimes you must do what is required",
                           "I agree with yours of the 22d that a professorship of Theology should have no place in our institution",
                           "The best preparation for tomorrow is doing your best today",
                           "Experience is the best teacher",
                           "A hero can go anywhere, challenge anyone as long as he has the nerve",
                           "The best listeners listen between the lines",
                           "The best is the enemy of good",
                           "The best work that anybody ever writes is the work that is on the verge of embarrassing him, always",
                           "I know I'm not going to be in your head all the time. But once you know me I'll be forever in your heart",
                           "The best gifts come from the heart, not the store",
                           "Drunken men give some of the best pep talks",
                           "The only way you can be the best at something is to be the best you can be",
                           "There are better people in the world, do not let the worst do the worst to you, you deserve the best in life"]
