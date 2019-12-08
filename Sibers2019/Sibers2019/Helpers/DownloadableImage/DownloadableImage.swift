//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class DownloadableImage: UIViewFromNib {
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        set(image: nil)
    }

    func set(url: URL) {
        set(image: nil)

        download(url: url) { [weak self] image in
            self?.set(image: image)
        }
    }

    func set(image: UIImage?) {
        let imageIsGood = image != nil

        if !imageIsGood {
            spinner.startAnimating()
        }
        else {
            spinner.stopAnimating()
        }

        imageView.image = image
        imageView.isHidden = !imageIsGood
    }

    private func download(url: URL, callback: @escaping (UIImage) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }

            guard let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                callback(image)
            }
        }

        task.resume()
    }
}
