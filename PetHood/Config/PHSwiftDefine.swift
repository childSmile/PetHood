//
//  PHSwiftDefine.swift
//  PetHood
//
//  Created by MacPro on 2024/7/9.
//

import UIKit


func tabbarHeight() -> CGFloat {
    return tabBarHeight()
}

func DHPXSW(s:CGFloat) -> CGFloat {
    return PHDHPXscale(s)
}


func kSemiBold_Montserrat(s:CGFloat) -> UIFont {
    return UIFont.init(name: "MontserratRoman-SemiBold", size: s) ?? UIFont.systemFont(ofSize: s)
}


func SafeArea_Bottom() -> CGFloat {
    return PHSafeArea_Bottom()
}

func keyWindow() -> UIWindow? {
    var window:UIWindow?
    if #available(iOS 13, *) {
        if #available(iOS 15, *) {
            window = UIApplication.shared.connectedScenes
                        .map({ $0 as? UIWindowScene })
                        .compactMap({ $0 })
                        .first?.windows.first
        }else{
            window = UIApplication.shared.windows.first
        }
    }else{
       window = UIApplication.shared.keyWindow
    }
    return window
}
