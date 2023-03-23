# regist

## 프로젝트 생성

- `flutter create 프로젝트명`
- `flutter create --org=com.kyoungmin movv` : com.kyoungmin.movv

## 간단한 정보들만 취합한 예약 시스템

- 구글 로그인을 통해서 예약 화면에 진입
- 예약 화면에서 날짜를 선택하고 구글 맵에서 출발지와 도착지점를
  선택하고 예약정보 확인란에서 인원 수와 출발시간 & 운송수단을 취합
- 예약하기 버튼을 누르면 모든 과정에서 정보가 잘 취합되었는지
  파악하기 위한 확인 팝업을 실행

## firebase 연동을 통한 예약 정보관리(예정)

- 예약 정보를 firebase 로 보내 저장하고
- main 페이지 단에서 client 예약정보를 확인&수정 할 수 있도록하기
- 관리자 단에서는 모든 client 예약정보를 확인 할 수 있도록하기

## 수정&추가해야 할 부분

- maps 진입 시 null check - done
- 출발지 도착지 거리 및 polyline 출력 - 했으나 정확한 route 는 direction api 가 한국 주소를 지원하지 않음 03-23일에 routes api 로 교체
- 예약 확인 화면
- 예약 정보 화면에서 예약 데이터 출력

## 카카오 API 키 해시 발급 받는 법

- android Studio\jre\bin 에서
  `./keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android keypass android | openssl sha1 -binary | openssl base64 `
