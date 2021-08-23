//
//  TenorGifCell.swift
//  Gifs Example
//
//  Created by Juan Garcia on 19/08/21.
//

import UIKit
import SDWebImage

class TenorGifCell: UICollectionViewCell {

    @IBOutlet weak var gifContainer: UIImageView!
    var mediaGif: Result? {
        didSet {
            guard let media = mediaGif else { return }
            let urlMedia = media.media.first { item in
                item.keys.contains { key in
                    key == "tinygif"
                }
            }
            let urlString = urlMedia?["tinygif"]?.url ?? ""
            guard let url = URL(string: urlString) else { return}
            gifContainer.sd_setImage(with: url)
        }
    }
    
    func setup(gif: Result) {
        mediaGif = gif
    }

    static func getCellSize(_ collectionView: UICollectionView,
                            aspectRatio: CGFloat) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
}
