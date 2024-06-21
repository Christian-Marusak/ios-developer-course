//
//  ImagesDownloadManager.swift
//  Course App
//
//  Created by Christián on 16/06/2024.
//

import UIKit.UIImage

typealias ImageIdResponse = (id: String, image: UIImage)

final class ImageService {
    let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    private func getImage(id: String) async throws -> ImageIdResponse {
        let data: Data = try await self.apiManager.request(ImagesRouter.size300x200)
        guard let image = UIImage(data: data) else {
            throw NetworkingError.badImageData
        }
        return (id, image)
    }
   
    func downloadImagesFor(ids: [String]) async throws -> [String : UIImage] {
        try await withThrowingTaskGroup(of: ImageIdResponse.self) { [weak self] group in
            guard let self else {
                return [:]
            }
                    
            ids.forEach { id in
                group.addTask {
                    try await self.getImage(id: id)
                }
            }
            
            var imagesDict: [String : UIImage] = [:]
                
            for try await imageIdResponse in group {
                imagesDict[imageIdResponse.id] = imageIdResponse.image
            }
            
            return imagesDict
        }
    }
}
