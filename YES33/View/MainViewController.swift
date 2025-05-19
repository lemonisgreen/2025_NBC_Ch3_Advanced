//
//  MainViewController.swift
//  YES33
//
//  Created by JIN LEE on 5/12/25.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    var disposeBag = DisposeBag()
    
    let searchBookTitle = UILabel()
    let searchBar = UISearchBar()
    let searchButton = UIButton()
    let bookResultsTitle = UILabel()
    
    private var bookResults = [Document]()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        bindViewModel()
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .filter { !$0.isEmpty } // 빈 문자열 검색 방지
            .map { MainViewModel.Input.result(keyword: $0) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
    
    @objc func searchButtonTapped() {
        print("검색 버튼 눌림!")
        guard let keyword = searchBar.text else { return }
        // 나중에 검색어 없을 시 사용자에게 알럿 띄우기
        self.viewModel.input.onNext(.result(keyword: keyword))
        searchBar.resignFirstResponder() // 검색 후 키보드 내리기
    }
    
    private func bindViewModel() {
        viewModel.output
            .observe(on: MainScheduler.instance) // UI 업데이트는 메인 스레드에서
            .subscribe(onNext: { [weak self] outputState in
                guard let self = self else { return }
         
                switch outputState {
                case .success(let books):
                    self.bookResults = books
                    self.collectionView.isHidden = books.isEmpty
                    self.collectionView.reloadData()
                    print("ViewModel: 데이터 로드 성공, 책 개수: \(books.count)")
                    
                case .failure(let error):
                    self.bookResults = []
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = true
                    print("ViewModel: 에러 발생 - \(error.localizedDescription)")
                    
                case .empty:
                    self.bookResults = []
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = true
                    print("ViewModel: 검색 결과 없음")
                }
            })
            .disposed(by: disposeBag)
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
        
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
    
    private func createLayout() -> UICollectionViewLayout {
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
    
    private func configureUI() {
        [
            searchBar,
            searchBookTitle,
            bookResultsTitle,
            collectionView,
            searchButton,
            
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchBookTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            searchBookTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            searchBar.topAnchor.constraint(equalTo: searchBookTitle.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            searchButton.topAnchor.constraint(equalTo: searchBookTitle.bottomAnchor, constant: 20),
            searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            bookResultsTitle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            bookResultsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            collectionView.topAnchor.constraint(equalTo: bookResultsTitle.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200),
            
        ])
    }
}

extension MainViewController: UISearchBarDelegate {
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedBookData = bookResults[indexPath.item]
        let detailModalVC = DetailModalViewController()
        
        detailModalVC.selectedBook = selectedBookData
        
        self.present(detailModalVC, animated: true, completion: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.id, for: indexPath) as? BookCell else { return UICollectionViewCell() }
        
        let book = bookResults[indexPath.item]
        cell.configure(with: book)
        
        return cell
    }
}
