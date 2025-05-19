# YES33

> ![unnamed](https://github.com/user-attachments/assets/9cdea5b4-b3f7-489c-afba-6c8669bec3e7)

# 📚 책 검색부터 저장까지 (CoreData & RxSwift)

> HTTP 통신과 CoreData를 활용하여 실제로 유용한 기능을 가진 앱을 만들어 보았습니다. 카카오 책 검색 API를 통해 책을 검색하고, 마음에 드는 책은 기기에 저장하여 언제든 다시 볼 수 있는 북마크 앱입니다.

---

# 🎯 주요 기능

1.  **도서 검색 (Kakao API & RxSwift/RxCocoa)**
    *   `UISearchBar`를 통해 키워드를 입력하면 실시간으로 또는 검색 버튼 클릭 시 카카오 책 검색 API를 호출하여 도서 목록을 가져옵니다.
    *   RxSwift와 RxCocoa를 활용하여 비동기 API 호출 및 UI 바인딩을 효율적으로 처리합니다.
    *   검색 결과는 `UICollectionView`를 통해 깔끔하게 표시됩니다.
2.  **도서 상세 정보 확인**
    *   검색 결과 목록에서 특정 책을 선택하면, 해당 책의 상세 정보(제목, 저자, 썸네일, 가격, 소개 등)를 보여주는 화면으로 전환됩니다.
3.  **책 저장 및 관리 (CoreData)**
    *   상세 화면에서 "책 담기" 버튼을 통해 선택한 책 정보를 기기의 CoreData에 영구적으로 저장합니다.
    *   저장된 책 목록을 별도의 화면(예: "내 서재" 또는 "장바구니")에서 확인하고 관리할 수 있습니다.
4.  **최근 본 책 목록 **
    *   사용자가 상세 정보를 확인한 책들을 자동으로 "최근 본 책" 목록에 저장하여, 메인 화면 등에서 쉽게 다시 접근할 수 있도록 합니다.

---

# 🛠️ 기술 스택

*   **UI:** `UIKit` (Code-based UI)
*   **Asynchronous Programming:** `RxSwift`, `RxCocoa`
*   **Networking:** `URLSession` (REST API 호출)
*   **Local Data Persistence:** `CoreData`
*   **Architecture:** MVVM
*   **IDE:** Xcode
*   **Language:** Swift

---

# 📦 설치 및 실행 방법

1.  이 저장소를 클론합니다:
    `git clone [https://github.com/lemonisgreen/2025_NBC_Ch3_Advanced.git]`
2.  Xcode에서 `.xcodeproj` 또는 `.xcworkspace` 파일을 엽니다.
3.  필요한 라이브러리(RxSwift, RxCocoa 등)가 CocoaPods 또는 Swift Package Manager를 통해 설치되어 있는지 확인하고, 설치되어 있지 않다면 설치합니다.
    *   **CocoaPods 사용 시:** `pod install` 실행
    *   **Swift Package Manager 사용 시:** Xcode가 자동으로 의존성을 해결합니다.
4.  빌드 후 시뮬레이터 또는 실제 기기에서 실행합니다.

    **주의:** 카카오 책 검색 API를 사용하기 위해서는 유효한 **REST API 키**가 필요합니다. 코드 내 API 키 입력 부분 (`CoreDataManager` 또는 네트워크 요청 부분)에 본인의 키를 입력해야 정상적으로 동작합니다.

---
