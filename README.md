# ATTI

---

## 사용한 오픈소스
### API
+ saltlux.ai - 텍스트 감정 분석
+ Instagram api
+ Sportify API

### 오픈소스 SW
+ 트위터 웹 크롤링
+ Firebase

### 라이브러리
CocoaPods로 설치  
```

  pod "BSImagePicker", "~> 3.1"
  pod "Alamofire", "~> 5.2"
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'youtube-ios-player-helper'
  pod 'Spotify', '~> 0.1'

```
---
## 시연 링크
https://drive.google.com/file/d/1vwCkmGRrudPiYtAKiOvlkC0iHfrkWwDJ/view?usp=sharing
---

## 업데이트

#### ~
// zeplin 등으로 구상


### 09.15
* Initial Commit

// 탭 바

### 09.27
**UserViewController.swift**: CollectionView로 유저뷰 제작. 로컬 DB로 Core Data 추가. 

**GlobalViewController.swift**: Firebase기반 서버로 커뮤니티 뷰 생성

**PlayViewController.swift**: Youtube 뮤비 재생 뷰 

### 09.28
* 다이어리 작성 뷰 추가(PickImgViewController).  

**PickImgViewController.swift**: 오픈소스 라이브러리 "BSImagePicker" 활용하여 이미지를 앨범에서 가져 옴(최대 10장). Core Data에 유저가 작성한 다이어리 내용(이미지, 본문, 내용, 날짜)을 로컬에 저장함.  

**UserViewController.swift**: Core Data에서 다이어리를 날짜순으로 로드하여 컬렉션뷰에 보여 줌.  

**GlobalDetailViewController.swift**: 작성한 다이어리 서버에 업로드, 수정, 삭제 기능 구현

### 09.29
**PickImgViewController.swift**: saltlux.ai의 텍스트 감정 분석을 사용하여 사용자가 작성한 다이어리 내용을 분석하여 8가지 감정으로 나눔.  

---
### 10.05
**SNSViewController.swift** : SNS 뷰에 인스타그램 API와 트위터 크롤링을 통해 해당 SNS에 게시된 아티스트의 게시물(이미지 및 텍스트)을 앱에 연결하여 사용자가 여러 SNS에 있는 아티스트의 소식을 한 번에 확인할 수 있게 하였습니다.

---
### 2022.03.08
**twitter, instagram 폴더** : 트위터와 인스타그램을 웹뷰를 통해 볼 수 있도록 
