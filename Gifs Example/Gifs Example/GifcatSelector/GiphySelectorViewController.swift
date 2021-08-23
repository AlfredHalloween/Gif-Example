//
//  GiphySelectorViewController.swift
//  Gifs Example
//
//  Created by Juan Garcia on 19/08/21.
//

import UIKit
import GfycatKit

class GiphySelectorViewController: GFYSimpleContainerViewController {
    
    @IBOutlet weak var gradientBar: GFYActivityGradientBar!
    @IBOutlet weak var mediaPreview: GFYMediaView!
    @IBOutlet weak var mediaTitle: UILabel!
    
    init() {
        let name = String(describing: GiphySelectorViewController.self)
        super.init(nibName: name, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been found")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mediaPreview.mediaFormat = .gif5mb
                
        let gfycatBrowserSettings = GFYBrowserSettings()
        gfycatBrowserSettings.enableSearchHistory = true
        // categories browsing settings
        gfycatBrowserSettings.categoryPickerSettings.scrollDirection = .horizontal
        gfycatBrowserSettings.categoryPickerSettings.enableRecentItems = true
        gfycatBrowserSettings.categoryPickerSettings.categoryMediaFormat = .gif2mb
        // media list browsing settings
        gfycatBrowserSettings.mediaPickerSettings.scrollDirection = .horizontal
        gfycatBrowserSettings.mediaPickerSettings.videoMediaFormat = .gif2mb
                
        let browser = GFYBrowserViewController(settings: gfycatBrowserSettings)
        browser.delegate = self
        //activeViewController = browser
    }
}

extension GiphySelectorViewController: GFYBrowserDelegate {

    func gfycatMediaPicker(_ picker: GFYMediaPickerViewController, didSelect media: GfycatMedia, with source: GFYArraySource) {
        mediaPreview.media = media
        mediaTitle.text = media.title
        gradientBar.active = true
    }
}

extension GiphySelectorViewController: GFYMediaViewDelegate {
    
    func gfyMediaView(_ mediaView: GFYMediaView, didStartPlayback media: GfycatReferencedMedia) {
        print("Playback started: \(media.gfyName)")
        GFYAnalyticsHub.shared.trackVideoPlayed(withGfyId: media.gfyId, context: .none, keyword: "preview", flow: .half)
        gradientBar.active = false
    }
}
