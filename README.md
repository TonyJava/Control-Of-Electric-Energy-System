# Control-Of-Electric-Energy-System

### 무슨 앱인가요?
이 프로젝트는 전기수도의 특성인 비배제성을 앱을 통해  전기를 제어하는 프로젝트입니다. 이 프로젝트를 시작하게 된 이유는 현재 학교 및 공공기관 등에서는 소프트웨어교육을 위한 실습실들을 보유하고 운영하고 있습니다. 윈도우 운영체제를 사용하고 있고, 모두 인터넷과 연결되어 있습니다. 현재 성공회대학교 내의 실습실 및 강의실 모두 해당합니다. 학교 내 컴퓨터의 개수는 총무처에서 확인해본 결과 1000대 가량으로 다른 기관에 비교해 많은 편은 아니지만 작은 수라도 모든 컴퓨터를 관리하기란 쉬운 일이 아닙니다. 또한, 강의실마다 있는 냉난방시설을 끄는 것도 쉬운 일이 아닌데, 이를 손쉽게 가능하도록 또 효과적으로 관리하는 방법을 고안한 것이 바로 ‘인절미’프로젝트입니다.

* 이 앱은 Android, iOS을 지원하고 서버는 AWS, 서버 언어는 PHP(Codeigniter), 윈도우 프로그램(C#)을 이용한 프로젝트입니다.


#### 인트로

<div align=center> 

<img src="/gif/intro.gif" width="400" height="700">

</div>

### 회원가입
앱이 공개되었을 때 관리자가 회원가입을 할 수 있도록 만들었습니다. 회원 가입한 데이터는 AWS의 서버와 연동되고 있습니다. 서버와 연결된 내용은 [다음을 참고](/server_codeigniter/readme.rst)해주세요.

<div align=center> 

<img src="/gif/signUp.gif" width="400" height="700">

</div>

### 로그인 실패
회원가입을 한 모든 회원이 로그인을 할 수 없도록 만들었습니다. 회원을 관리하는 최종관리자가 승인을 해주어야 회원 로그인을 할 수 있습니다.

<div align=center> 

<img src="/gif/loginFail.gif" width="400" height="700">

</div>

### 관리자 아이디로 로그인
최종관리자로 로그인합니다.

<div align=center> 

<img src="/gif/adminLogin.gif" width="400" height="700">

</div>

### 전기제어
최종관리자로 현재 강의실에 접속된 컴퓨터들을 확인하고 그 컴퓨터를 종료할 수 있습니다. 해당 컴퓨터를 종료하는 프로그램은 [다음을 참조](/window-client/readme.rst)해주세요.

<div align=center> 

<img src="/gif/controlEnergy.gif" width="400" height="700">

</div>

### 로그인 권한 부여하기
최종관리자로 방금 회원가입한 회원의 관리등급을 높여 로그인을 가능하도록 합니다.

<div align=center> 

<img src="/gif/loginAutu.gif" width="400" height="700">

</div>

### 로그인 성공
회원등급이 올라간 회원이 로그인에 성공하는 모습입니다.

<div align=center> 

<img src="/gif/loginSuccess.gif" width="400" height="700">

</div>
