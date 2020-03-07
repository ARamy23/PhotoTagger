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
    
    func uploadImage(_ progress: @escaping (Double) -> Void) -> Promise<TagsAndColorsResponse> {
        return network
            .callAPIWithProgress(
                api: ImaggaRouter.content(compress(image)),
                model: String.self, progress
        ).then(fetchTagsAndColors)
    }
    
    private func compress(_ image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 0.5) ?? Data()
    }
    
    private func fetchTagsAndColors(contentID: String) -> Promise<TagsAndColorsResponse> {
        return network.call(api: ImaggaRouter.tags(contentID), model: [String].self)
            .then { (tags) -> Promise<TagsAndColorsResponse> in
                return Promise<TagsAndColorsResponse> { fullfil, reject in
                    let colorsPromise = self.network.call(api: ImaggaRouter.colors(contentID), model: [PhotoColor].self)
                    colorsPromise.then { (colors) in
                        fullfil(TagsAndColorsResponse(tags, colors))
                    }.catch(reject)
                }
        }
    }
}

struct TagsAndColorsResponse: Codable {
    let tags: [String]
    let colors: [PhotoColor]
    
    init(_ tags: [String], _ colors: [PhotoColor]) {
        self.tags = tags
        self.colors = colors
    }
}
