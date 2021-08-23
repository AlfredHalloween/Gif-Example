//
//  CustomTheme.swift
//  Gifs Example
//
//  Created by Juan Garcia on 18/08/21.
//

import Foundation
import GiphyUISDK

public class CustomTheme: GPHTheme {
    public override init() {
        super.init()
        self.type = .light
    }
    
    public override var textFieldFont: UIFont? {
        return UIFont.italicSystemFont(ofSize: 15.0)
    }
    
    public override var textColor: UIColor {
        return .black
    }
}
