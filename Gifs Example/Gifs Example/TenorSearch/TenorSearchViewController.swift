//
//  TenorSearchViewController.swift
//  Gifs Example
//
//  Created by Juan Garcia on 19/08/21.
//

import UIKit
import Alamofire

protocol TenorSearchViewControllerDelegate: AnyObject {
    func didSelectTenorGif(_ viewController: TenorSearchViewController, gif: Media?)
}

class TenorSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var list: [Result] = [Result]()
    private let identifier: String = String(describing: TenorGifCell.self)
    weak var delegate: TenorSearchViewControllerDelegate?
    
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
        
        AF.request("https://g.tenor.com/v1/trending?key=CJ5MWSDRPCB2&limit=15", method: .get)
            .responseJSON { response in
                do {
                    guard let data = response.data,
                          let listObjects = try? JSONDecoder().decode(TenorModel.self, from: data) else {
                        return
                    }
                    print("Gifs count: \(listObjects.results.count)")
                    self.list.append(contentsOf: listObjects.results)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
    }
}

extension TenorSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = list[indexPath.row]
        let urlMedia = image.media.first { item in
            item.keys.contains { key in
                key == "tinygif"
            }
        }
        let media = urlMedia?["tinygif"]
        delegate?.didSelectTenorGif(self, gif: media)
    }
}

extension TenorSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TenorGifCell else {
            fatalError("Error creating cell")
        }
        cell.setup(gif: list[indexPath.row])
        return cell
    }
}

extension TenorSearchViewController: GifCollectionFlowLayoutDelegate {
    func numberOfColumns() -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = list[indexPath.row]
        let urlMedia = image.media.first { item in
            item.keys.contains { key in
                key == "tinygif"
            }
        }
        let media = urlMedia?["tinygif"]
        let width: CGFloat = collectionView.frame.width / 2
        let height: CGFloat = width / (media?.aspectRatio ?? 1)
        return height
    }
}

