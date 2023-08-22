//
//  Data+OfAsset.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation
import UIKit.UIImage

extension Data {
    static func fromAsset(withName assetName: String) -> Data {
        UIImage(named: assetName)?.pngData() ?? Data()
    }
}
