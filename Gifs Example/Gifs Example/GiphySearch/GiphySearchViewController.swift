//
//  ViewController.swift
//  Gifs Example
//
//  Created by Juan Garcia on 18/08/21.
//

import UIKit
import Alamofire

protocol GiphySearchViewControllerDelegate: AnyObject {
    func didSelectGiphyGif(_ viewController: GiphySearchViewController, gif: Datum)
}

final class GiphySearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let identifier: String = String(describing: GifCell.self)
    private var list: [Datum] = [Datum]()
    weak var delegate: GiphySearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib: UINib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = GifCollectionFlowLayout()
        collectionView.collectionViewLayout = flowLayout
        if let layout = collectionView?.collectionViewLayout as? GifCollectionFlowLayout {
          layout.delegate = self
        }
        AF.request("https://api.giphy.com/v1/gifs/trending?api_key=3cnbZoVHzjxrnnn48tuLOmvQykngg7nA&limit=20",
                   method: .get)
            .responseJSON { response in
                do {
                    guard let data = response.data,
                          let listObjects = try? JSONDecoder().decode(Welcome.self, from: data) else {
                        return
                    }
                    self.list.append(contentsOf: listObjects.data)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
    }
}

extension GiphySearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = list[indexPath.row]
        delegate?.didSelectGiphyGif(self, gif: image)
    }
}

extension GiphySearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? GifCell else {
            fatalError("Error creating cell")
        }
        cell.setup(gif: list[indexPath.row], collectionView: collectionView)
        return cell
    }
}

extension GiphySearchViewController: GifCollectionFlowLayoutDelegate {
    func numberOfColumns() -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = list[indexPath.row].images.fixedWidthSmall
        let aspectRatio: CGFloat = CGFloat(Float(image.width) ?? 0) / CGFloat(Float(image.height) ?? 0)
        let width: CGFloat = collectionView.frame.width / 2
        let height: CGFloat = width / aspectRatio
        return height
    }
}
