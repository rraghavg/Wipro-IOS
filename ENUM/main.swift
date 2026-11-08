//
//  main.swift
//  ENUM
//
//  Created by Raghav Gupta on 07/11/26.
//

import Foundation

enum SocialPlatform: String, CaseIterable{
    case x         = "I never use it"
    case instagram = "Socially accepted"
    case facebook  = "Old gen use it"
    case linkedIN  = "Professionally accpeted"
}

func shareImage(on platform: SocialPlatform){
    switch platform{
        
    case .x:
        print("this is where the code goes and share image to x.")
    case .instagram:
        print("this is where the code goes and share image to instagram.")
    case .facebook:
        print("this is where the code goes and share image to facebook.")
    case .linkedIN:
        print("this is where the code goes and share image to linkedIN.")
    }
}

//shareImage(on: .linkedIN)

func myopinion(on platform:SocialPlatform){
    print(platform.rawValue)
}

//myopinion(on: .instagram)

//for platform in SocialPlatform.allCases{
//    print(platform.rawValue)
//}

enum SocialMediaPlatform{
    case x(followers:Int)
    case youtube(subscribers: Int)
    case insta(followers: Int)
    case facebook(followers: Int)
}

func getsponsership(for platform : SocialMediaPlatform){
    
}
