# ATTI

### 사용한 오픈소스
#### API
saltlux.ai

#### 라이브러리
CocoaPods로 설치
₩₩₩
  pod "BSImagePicker", "~> 3.1"
  pod "Alamofire", "~> 5.2"
₩₩₩

---

#### 09.27
UserViewController.swift: CollectionView로 유저뷰 제작. 로컬 DB로 Core Data 추가.  

---

#### 09.28
**다이어리 작성 뷰 추가(PickImgViewController).**
PickImgViewController.swift: 오픈소스 라이브러리 "BSImagePicker" 활용하여 이미지를 앨범에서 가져 옴(최대 10장). Core Data에 유저가 작성한 다이어리 내용(이미지, 본문, 내용, 날짜)을 로컬에 저장함.  
UserViewController.swift: Core Data에서 다이어리를 날짜순으로 로드하여 컬렉션뷰에 보여 줌.  

#### 09.29
PickImgViewController.swift: saltlux.ai의 텍스트 감정 분석을 사용하여 사용자가 작성한 다이어리 내용을 분석하여 8가지 감정으로 나눔.  
