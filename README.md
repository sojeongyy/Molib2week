# Dumb Ways To Die - Gongdae Version

약칭: Dumb Ways Gongdae

## Outline

---

저희 앱은 기존에 있던 Dumb Ways To Die 게임을 공대버전으로 재해석하여 만든 미니게임입니다. 

- 다양한 게임을 한번에 할 수 있어요
- 귀여운 캐릭터들이 다양하게 등장해요
- 뒤로 갈수록 어려워지는 게임 → 최고 점수를 기록해보세요!

## Team

---

[김소정](https://www.notion.so/05f7a77d40ef42b0aa2125eb14255002?pvs=21)

[sojeongyy - Overview](https://github.com/sojeongyy)

[조성호](https://www.notion.so/992912748c4d403eac154577e901beea?pvs=21)

[Seongho-Cho12 - Overview](https://github.com/Seongho-Cho12)

## Tech Stack

---

### FE

- flutter
- Android Studio

### BE

---

- Node.js
- MySQL

# Details

---

## 첫 화면

- 앱에 들어갔을 때의 첫 화면입니다.
- LOGIN 버튼을 누르면 로그인 화면으로 넘어가요.
- `AnimationController`를 이용해 로고에 애니메이션을 추가하였습니다.
- `AudioPlayer`를 이용해 Dumb Ways To Die 주제곡을 배경음악으로 넣었습니다.

## 로그인 화면

- 로그인 및 회원가입을 할 수 있습니다.
    - 앱 자체 로그인
    - 카카오톡 연동 로그인

### 회원가입

- 앱에 계정이 존재하지 않을 시 회원가입을 해야합니다.
- 카카오톡으로 로그인을 하더라도, 연동되지 않은 계정이라면 앱 자체 회원가입을 진행합니다.


### 카카오톡 연동

- 카톡으로 연동 시 점수를 친구에게 공유할 수 있습니다.
- 카톡 프로필을 가져올 수 있습니다.
- 연동을 했더라도 언제든지 연동을 끊을 수 있습니다. (재연동도 가능!)


### 로그인 유지

- 로그인 화면에서 로그인 유지 버튼으로 앱에서 나간 뒤에도 로그인을 유지할 수 있습니다.
- 로그인 유지를 체크한 경우 기존에 로그인한 계정으로 자동으로 로그인됩니다.


## 홈 화면

- 로그인 성공 시 게임의 홈화면입니다.
- `AnimationController`를 이용해 화면 상단에 비행기 애니메이션을 구현했습니다.

### 스코어보드

- 나의 TOP3 점수를 볼 수 있어요.
- 높은 점수를 갱신 시에 실시간으로 반영됩니다.


### 프로필

- 오른쪽 상단의 프로필 버튼을 누르면 자신의 프로필을 볼 수 있습니다.
- 카카오톡 프로필
- 닉네임
- 카카오톡을 연동하거나 연동을 끊을 수 있습니다.
- 로그아웃


### 플레이

- 플레이 버튼을 누르면 바로 게임 시작입니다!

## Game 1 - 이상형을 맞춰봐잇

> *공대 CC를 만들어보아요!*
> 

- 가운데 여자 캐릭터의 말풍선을 보고 알맞은 캐릭터를 매치시켜야 합니다.
- 정답 캐릭터를 슬라이드하여 여자 캐릭터에게 가져다 주세요.
- 다른 캐릭터를 슬라이드 시 여자 캐릭터에게 욕을 먹을 수 있어요!
- 시간 안에 가져다 주지 않아도 욕을 먹을 수 있어요!

### If U Success…

- 공대 CC 탄생!
- 다음 라운드로 넘어갑니다.
- 다음 라운드는 분명 더 어려울 것..

### If U Fail…

- 게임 실패!
- check your score 버튼 선택 시 게임 오버 화면으로


## Game 2 - 교수님에게서 도망쳐라잇

> *잡히는 순간 대학원생*
> 


- 쫓아오는 교수님으로부터 도망치세요!
- 슬라이드를 이용해서 도망칠 수 있습니다.
- 라운드가 뒤로 갈 수록 교수님이 축지법을 써요!

### If U Success…

- 교수님으로부터 탈출 성공
- 다음 라운드로 넘어갑니다.


### If U Fail…

- 바로 대학원생행
- 게임 실패!
- check your score 버튼 선택 시 게임 오버 화면으로


## Game 3 - 컴퓨터의 BUG를 잡아라

> *LET’S DEBUG*
> 

![KakaoTalk_20250108_201322001 - frame at 1m43s.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/190c8a02-cf6c-461e-836d-b82c0cfe9c9a/KakaoTalk_20250108_201322001_-_frame_at_1m43s.jpg)

- 컴퓨터에 붙어있는 BUG를 잡으세요!
- BUG는 절대 한 마리가 아닙니다..
- 뒤로 갈 수록 더욱 늘어납니다.

### If U Success…

- 기쁩니다.
- Next 버튼으로 다음 라운드 이동!

![KakaoTalk_20250108_201322001 - frame at 1m46s.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/fc9b0878-9840-4063-bf72-79da8f43ec30/KakaoTalk_20250108_201322001_-_frame_at_1m46s.jpg)

### If U Fail…

- BUG에게 비웃음을 삽니다.
- 게임 실패!
- check your score 버튼 선택 시 게임 오버 화면으로

![image.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/68bb135d-711e-4d1f-be10-d3a8b8be1ca4/image.png)

## Game 4 - 어! 금지

> *개발자 3대 금지어*
> 

![image.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/52c8c0eb-523a-406e-a665-3bb2bf23675e/image.png)

- 어! 말풍선을 선택해 입을 막으세요.
- 다른 말풍선을 선택하면 바로 게임오버..
- 라운드가 뒤로 가면 헉!도 금지입니다ㅎㅎ

### If U Success…

- 에러가 무섭지 않게 됩니다.
- ~~저 더 이상 아무것도 무섭지 않아요~~
- Next 버튼으로 다음 라운드 이동!

![image.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/b7aca596-3361-4a74-abe0-01270b6b536a/image.png)

### If U Fail…

- 어! 금지
- 게임 실패!
- check your score 버튼 선택 시 게임 오버 화면으로

![image.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/fb11ac42-1702-415a-add2-f03228599731/image.png)

## Game Over 페이지

![KakaoTalk_20250108_201322001 - frame at 2m0s.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/d0be00e9-a79a-4d83-a096-c91794b2d309/KakaoTalk_20250108_201322001_-_frame_at_2m0s.jpg)

![KakaoTalk_20250108_201322001 - frame at 1m19s.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/ae403a94-e6cf-4640-9b7b-7cfb90698ef2/KakaoTalk_20250108_201322001_-_frame_at_1m19s.jpg)

![KakaoTalk_20250108_201322001 - frame at 1m15s.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/f6cb388f-3934-47d6-9928-26d2e10eb0fc/6a54644f-8a35-4790-b360-ca7e01ad0d04/KakaoTalk_20250108_201322001_-_frame_at_1m15s.jpg)

- 최종 점수를 확인할 수 있어요.
- 다시 홈으로 돌아가거나
- 재도전을 할 수 있어요!
- share 버튼을 누르면 카톡으로 친구에게 자신의 점수를 공유할 수 있어요!

# APK
