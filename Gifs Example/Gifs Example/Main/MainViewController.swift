//
//  MainViewController.swift
//  Gifs Example
//
//  Created by Juan Garcia on 19/08/21.
//

import UIKit
import GiphyUISDK
import SDWebImage

class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openGiphy() {
        let giphy = GiphySearchViewController()
        giphy.delegate = self
        present(giphy, animated: true)
    }
    
    @IBAction func openTenor() {
        let tenor = TenorSearchViewController()
        tenor.delegate = self
        present(tenor, animated: true)
    }
    
    @IBAction func openGiphySDK() {
        let giphy = GiphyViewController()
        giphy.delegate = self
        present(giphy, animated: true)
    }
}

extension MainViewController: GiphyDelegate {
    func didDismiss(controller: GiphyViewController?) {
        
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        let width: CGFloat = view.frame.width
        let height: CGFloat = width / media.aspectRatio
        constraintHeight.constant = height
        if let urlString = media.url(rendition: .fixedHeight, fileType: .gif),
           let url = URL(string: urlString) {
            imageView.sd_setImage(with: url)
        }
        giphyViewController.dismiss(animated: true)
    }
}

extension MainViewController: GiphySearchViewControllerDelegate {
    func didSelectGiphyGif(_ viewController: GiphySearchViewController, gif: Datum) {
        let image = gif.images.fixedHeight
        let aspectRatio: CGFloat = CGFloat(Float(image.width) ?? 0) / CGFloat(Float(image.height) ?? 0)
        let width: CGFloat = view.frame.width
        let height: CGFloat = width / aspectRatio
        constraintHeight.constant = height
        if let url = URL(string: image.url) {
            imageView.sd_setImage(with: url)
        }
        viewController.dismiss(animated: true)
    }
}

extension MainViewController: TenorSearchViewControllerDelegate {
    func didSelectTenorGif(_ viewController: TenorSearchViewController, gif: Media?) {
        
        guard let urlString = gif?.url,
              let url = URL(string: urlString) else { return}
        let width: CGFloat = view.frame.width
        let height: CGFloat = width / (gif?.aspectRatio ?? 1)
        constraintHeight.constant = height
        imageView.sd_setImage(with: url)
        viewController.dismiss(animated: true)
    }
}
