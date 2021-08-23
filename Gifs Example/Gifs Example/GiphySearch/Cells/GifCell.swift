//
//  GifCell.swift
//  Gifs Example
//
//  Created by Juan Garcia on 18/08/21.
//

import UIKit
import GiphyUISDK
import SDWebImage

class GifCell: UICollectionViewCell {
    @IBOutlet weak var imageContainer: UIImageView!
    
    var mediaGif: Datum? {
        didSet {
            guard let media = mediaGif else { return }
            let webpURL = media.images.fixedWidthSmall.url
            let url = URL(string: webpURL)
            imageContainer.sd_setImage(with: url)
        }
    }
    
    func setup(gif: Datum, collectionView: UICollectionView) {
        mediaGif = gif
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaGif = nil
    }
    
    static func getCellSize(_ collectionView: UICollectionView, aspectRatio: CGFloat) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2
        let height: CGFloat = width / aspectRatio
        return CGSize(width: width, height: height)
    }
}
