//
//  MainViewModel.swift
//  YES33
//
//  Created by JIN LEE on 5/14/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    enum Input {
        case result(keyword: String)
    }
    
    enum Output {
        case success(books: [Document])
        case failure(error: Error)
        case empty
    }
    
    let input = PublishSubject<Input>()
    let output = PublishSubject<Output>()
    
    private let disposeBag = DisposeBag()
    
    //let bookResultsSubject = BehaviorSubject(value: [Document]())
    
    init() {
        input.flatMapLatest { [weak self] inputAction -> Observable<Output> in // inputAction으로 변수명 변경 권장
            guard let self = self else { return .empty() } // self가 nil이면 빈 Observable 반환
            
            switch inputAction {
            case .result(let keyword):
                // fetchBookResults 함수가 Observable<Output>을 반환하므로,
                // 이를 직접 반환하여 flatMapLatest가 처리하도록 합니다.
                // 로딩 상태를 먼저 방출하고 API 호출을 시작합니다.
                return Observable.concat([
                    self.fetchBookResults(keyword: keyword) // API 호출 결과를 Observable<Output>으로 받음
                ])
            }
        }
        .bind(to: output) // fetchBookResults에서 반환된 Observable<Output>의 결과를 output Subject에 바인딩
        .disposed(by: disposeBag)
    }
    
    func fetchBookResults(keyword: String) ->Observable<Output> {
        return Observable<Output>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            guard let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(keyword)") else {
                let urlError = NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for keyword: \(keyword)"])
                observer.onNext(.failure(error: urlError))
                observer.onCompleted()
                return Disposables.create()
            }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Authorization": "KakaoAK 697fd675657f803525ec0123d2557bf3"]
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
//                guard let data = data else { /* ... */ return }
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("--- Received API JSON Response ---")
//                    print(jsonString)
//                    print("-------------------------------")
//                }
                
                if let error = error {
                    // 네트워크 에러 처리
                    print("Error: \(error.localizedDescription)")
                    observer.onNext(.failure(error: error))
                    observer.onCompleted()
                    return
                }
                
                guard let data = data else {
                    // 데이터 없음 에러 처리
                    print("Error: No data received")
                    let noDataError = NSError(domain: "NetworkError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    observer.onNext(.failure(error: noDataError)) // Output.failure 이벤트 발생
                    observer.onCompleted()
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let bookSearchResponse = try decoder.decode(BookResponse.self, from: data)
                    
                    if bookSearchResponse.documents.isEmpty {
                        observer.onNext(.empty) // Output.empty 이벤트 발생
                    } else {
                        observer.onNext(.success(books: bookSearchResponse.documents)) // Output.success 이벤트 발생
                    }
                    observer.onCompleted()
                    
                } catch let decodingError {
                    // JSON 디코딩 에러 처리
                    print("Error: Decoding Error")
                    observer.onNext(.failure(error: decodingError)) // Output.failure 이벤트 발생
                    observer.onCompleted()
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
