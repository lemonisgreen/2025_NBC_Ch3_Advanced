//
//  NetworkManager.swift
//  YES33
//
//  Created by JIN LEE on 5/14/25.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidURL
    case dataFetchingFailed22
    case decodingFailed
    case 이건무슨오류일꼬
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let apiKey: String = "697fd675657f803525ec0123d2557bf3"
    
    //    func fetch<T: Decodable>(url: URL) -> Single<T> {
    //
    //        // 2. 요청 생성
    //        var request = URLRequest(url: url)
    //        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization") // ✅ 헤더 추가
    //
    //        return Single.create { observer in
    //            let session = URLSession(configuration: .default)
    //            session.dataTask(with: URLRequest(url: url)) { data, response, error in
    //                if let error = error {
    //                    observer(.failure(error))
    //                    return
    //                }
    //
    //                guard let data = data,
    //                      let response = response as? HTTPURLResponse,
    //                      (200..<300).contains(response.statusCode) else {
    //                    observer(.failure(NetworkError.dataFetchingFailed22))
    //                    return
    //                }
    //
    //                do {
    //                    let decodedData = try JSONDecoder().decode(T.self, from: data)
    //                    observer(.success(decodedData))
    //                } catch {
    //                    observer(.failure(NetworkError.이건무슨오류일꼬))
    //                }
    //            }.resume()
    //
    //            return Disposables.create()
    //        }
    //    }
    //}
    
}
