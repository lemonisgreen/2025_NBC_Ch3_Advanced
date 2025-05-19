//
//  MainViewController.swift
//  YES33
//
//  Created by JIN LEE on 5/12/25.
//

import UIKit
import RxSwift
import SnapKit
import CoreData

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    var disposeBag = DisposeBag()
    
    let searchBookTitle = UILabel()
    let searchBar = UISearchBar()
    let searchButton = UIButton()
    let bookResultsTitle = UILabel()
    let recentlyViewedBookTitle = UILabel()
    
    private var bookResults = [Document]()
    private var recentlyViewedBooks = [RecentlyViewedBook]()
    
    private lazy var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createSearchResultLayout())
    private lazy var recentlyViewedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createRecentlyViewedLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        bindViewModel()
        loadRecentlyViewedBooks()
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty } // 빈 문자열 검색 방지
            .map { MainViewModel.Input.result(keyword: $0) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
    
    @objc func searchButtonTapped() {
        print("검색 버튼 눌림!")
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            //나중에 알럿 추가
            return
        }
        self.viewModel.input.onNext(.result(keyword: keyword))
        searchBar.resignFirstResponder()
    }
    
    private func bindViewModel() {
        viewModel.output
            .observe(on: MainScheduler.instance) // UI 업데이트는 메인 스레드에서
            .subscribe(onNext: { [weak self] outputState in
                guard let self = self else { return }
                
                switch outputState {
                case .success(let books):
                    self.bookResults = books
                    self.searchResultCollectionView.isHidden = books.isEmpty
                    self.searchResultCollectionView.reloadData()
                    print("ViewModel: 데이터 로드 성공, 책 개수: \(books.count)")
                    
                case .failure(let error):
                    self.bookResults = []
                    self.searchResultCollectionView.reloadData()
                    self.searchResultCollectionView.isHidden = true
                    print("ViewModel: 에러 발생 - \(error.localizedDescription)")
                    
                case .empty:
                    self.bookResults = []
                    self.searchResultCollectionView.reloadData()
                    self.searchResultCollectionView.isHidden = true
                    print("ViewModel: 검색 결과 없음")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadRecentlyViewedBooks() {
        
        let fetchedBooks = CoreDataManager.shared.fetchAllRecentlyViewedBooks(limit: 10)
        
        self.recentlyViewedBooks = fetchedBooks
        self.recentlyViewedCollectionView.isHidden = fetchedBooks.isEmpty
        self.recentlyViewedCollectionView.reloadData()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.placeholder = "책 제목, 작가, 출판사 등을 입력하세요."
        searchBar.backgroundImage = UIImage() // border 제거
        
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        searchBookTitle.attributedText = NSAttributedString(string: "도서 검색", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        
        bookResultsTitle.attributedText = NSAttributedString(string: "검색 결과", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        
        recentlyViewedBookTitle.attributedText = NSAttributedString(string: "최근 본 책", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        
        recentlyViewedCollectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.id)
        recentlyViewedCollectionView.delegate = self
        recentlyViewedCollectionView.dataSource = self
        recentlyViewedCollectionView.backgroundColor = .white
        
        searchResultCollectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.id)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.backgroundColor = .white
        
        
    }
    
    private func createSearchResultLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .estimated(200)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createRecentlyViewedLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(220)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureUI() {
        [
            searchBookTitle, searchBar, searchButton, // 검색 관련 UI
            bookResultsTitle, searchResultCollectionView, // 검색 결과 UI
            recentlyViewedBookTitle, recentlyViewedCollectionView // 최근 본 책 UI
            
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchBookTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            searchBookTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBookTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchBar.topAnchor.constraint(equalTo: searchBookTitle.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bookResultsTitle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            bookResultsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookResultsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchResultCollectionView.topAnchor.constraint(equalTo: bookResultsTitle.bottomAnchor, constant: 8),
            searchResultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultCollectionView.bottomAnchor.constraint(equalTo: recentlyViewedBookTitle.topAnchor, constant: -20),
            
            recentlyViewedBookTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentlyViewedBookTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recentlyViewedCollectionView.topAnchor.constraint(equalTo: recentlyViewedBookTitle.bottomAnchor, constant: 8),
            recentlyViewedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentlyViewedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentlyViewedCollectionView.heightAnchor.constraint(equalToConstant: 250),
            recentlyViewedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension MainViewController: UISearchBarDelegate {
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == searchResultCollectionView {
            let selectedBookFromSearch = bookResults[indexPath.item]
            let detailModalVC = DetailModalViewController()
            
            detailModalVC.selectedBook = selectedBookFromSearch
            
            self.present(detailModalVC, animated: true, completion: nil)
            collectionView.deselectItem(at: indexPath, animated: true)
            
            CoreDataManager.shared.saveBookToRecentlyViewedBook(bookData: selectedBookFromSearch)
            loadRecentlyViewedBooks()
            
        } else if collectionView == recentlyViewedCollectionView {
            let selectedRecentlyViewed = recentlyViewedBooks[indexPath.item]
            
            let documentToShow = Document(
                title: selectedRecentlyViewed.title,
                contents: selectedRecentlyViewed.contents,
                url: nil, // 필요한 경우 채움
                isbn: nil, // 필요한 경우 채움
                datetime: nil, // 필요한 경우 채움
                authors: selectedRecentlyViewed.authorsArray, // 계산된 프로퍼티 사용
                publisher: nil, // 필요한 경우 채움
                translators: nil, // 필요한 경우 채움
                price: selectedRecentlyViewed.priceValue, // 계산된 프로퍼티 사용
                salePrice: nil, // 필요한 경우 채움
                thumbnail: selectedRecentlyViewed.thumbnail,
                status: nil // 필요한 경우 채움
            )
            
            let detailModalVC = DetailModalViewController()
            
            detailModalVC.selectedBook = documentToShow
            
            self.present(detailModalVC, animated: true, completion: nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchResultCollectionView {
            return bookResults.count
        } else if collectionView == recentlyViewedCollectionView {
            return recentlyViewedBooks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.id, for: indexPath) as? BookCell else { return UICollectionViewCell() }
        
        if collectionView == searchResultCollectionView {
            let book = bookResults[indexPath.item]
            cell.configure(with: book)
        } else if collectionView == recentlyViewedCollectionView {
            let recentlyViewedItem = recentlyViewedBooks[indexPath.item]
            cell.configure(with: recentlyViewedItem)
        }
        return cell
    }
}
