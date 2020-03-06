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

import Moya

enum ImaggaRouter {
    case content(Data)
    case tags(String)
    case colors(String)
}

extension ImaggaRouter: TargetType {
    static let baseURLPath = "http://api.imagga.com/v1"
    static let authenticationToken = "Basic xxx"
    
    public var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL {
        return URL(string: Self.baseURLPath)!
    }
    
    var method: Moya.Method {
        switch self {
        case .content:
            return .post
        case .tags, .colors:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .content:
            return "/content"
        case .tags:
            return "/tagging"
        case .colors:
            return "/colors"
        }
    }
    
    public var task: Task {
        switch self {
        case .tags(let contentID):
            return .requestParameters(parameters: ["content": contentID], encoding: URLEncoding.default)
        case .colors(let contentID):
            return .requestParameters(parameters: ["content": contentID, "extract_object_colors": 0], encoding: URLEncoding.default)
        case let .content(imageData):
            var formData: [MultipartFormData] = [MultipartFormData(
                provider: .data(imageData),
                name: "imagefile",
                fileName: "image.jpg",
                mimeType: "image/jpeg")]
            return .uploadMultipart(formData)
        }
    }
    
    public var headers: [String : String]? {
        return ["Authorization": Self.authenticationToken]
    }
}
