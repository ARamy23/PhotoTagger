/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Alamofire

class ViewController: UIViewController, Routable {
    
    // MARK: - IBOutlets
    @IBOutlet var takePictureButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    fileprivate var tags: [String]?
    fileprivate var colors: [PhotoColor]?
    
    lazy var viewModel = SelectPhotoViewModel(router: self.router)
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewDidLoad()
    }
    
    private func bind() {
        viewModel.takePhotoButtonTitle.bind = { self.takePictureButton.setTitle($0, for: .normal) }
        viewModel.isProgressBarVisibile.bind = { self.progressView.isHidden = !$0 }
        viewModel.photo.bind = { self.imageView.image = $0 }
        viewModel.progressBarProgress.bind = { self.progressView.progress = Float($0) }
        viewModel.isTakePhotoButtonVisibile.bind = { self.takePictureButton.isHidden = !$0 }
        viewModel.shouldAnimateActivityIndicator.bind = {
            $0 ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    // MARK: - IBActions
    @IBAction func takePicture(_ sender: UIButton) {
        viewModel.takePicture()
    }
}
