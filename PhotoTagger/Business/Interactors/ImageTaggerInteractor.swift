//
//  ImageTaggerInteractor.swift
//  PhotoTagger
//
//  Created by Ahmed Ramy on 3/6/20.
//  Copyright © 2020 Razeware LLC. All rights reserved.
//

import UIKit.UIImage
import Promises

struct ImageTaggerInteractor {
    let image: UIImage
    let network: NetworkProtocol
    
    init(image: UIImage, network: NetworkProtocol) {
        self.image = image
        self.network = network
    }
    
    func uploadImage(_ progress: @escaping (Double) -> Void) -> Promise<String> {
        return network
            .callAPIWithProgress(
                api: ImaggaRouter.content(compress(image)),
                model: String.self, progress
            )
    }
    
    private func compress(_ image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 0.5) ?? Data()
    }
    
    func fetchTagsAndColors(contentID: String) -> Promise<([String], [PhotoColor])> {
        return network.call(api: ImaggaRouter.tags(contentID), model: [String].self)
            .then { (tags) -> Promise<([String], [PhotoColor])> in
                return Promise<([String], [PhotoColor])> { fullfil, reject in
                    let colorsPromise = self.network.call(api: ImaggaRouter.colors(contentID), model: [PhotoColor].self)
                    colorsPromise.then { (colors) in
                        fullfil((tags, colors))
                    }.catch(reject)
                }
        }
    }
}
