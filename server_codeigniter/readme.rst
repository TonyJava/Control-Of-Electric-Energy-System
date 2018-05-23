################
Bugking API 사용법
################


무슨 프로그램인지 이해가 안되신다면 http://bug.lasel.kr/blog/?p=198 를 참고해주세요!!


해당API는 PHP로 작성되었으며 프레임워크는 CodeIgniter을 사용하였습니다. 

데이터는 JSON 형식으로 전송됩니다. 또한 개인정보는 bcrypt로 암호화되어 저장됩니다. 

토큰 발행은 sha256 암호화방식을 이용하여 작성하였습니다.

예시는 다음과 같습니다.

{
   code           :       200,
   message        :       "Success",
   data           :       "data"
}

code는 Int, message와 data는 String으로 전송됩니다.


다음은 code 정보입니다.

1) 200 - 성공

2) 201 - 관리자 로그인

3) 202 - shutdown

4) 300 - 파라미터가 없습니다.

5) 301 - 쿼리문 오류

6) 302 - 비밀번호 오류

7) 303 - 아이디 중복

8) 304 - 로그인 횟수 초과

9) 305 - 토큰 만료

10) 306 - 맥주소가 존재합니다.

11) 400 - Bad Request

12) 401 - 인증, 인가 실패

13) 404 - 해당 리소스를 찾을 수 없습니다.

14) 500 - Internal Error - 서버 에러
	

<App 인절미 API>

1. 회원가입 ((개인url)/users/registration)
 - Parameters : id, pwd
 - data : 없음
 - 회원가입한 정보는 암호화되어 저장됩니다.
 - code : 200, 300, 303
 
2. 로그인 ((개인url)/users/login)
 - Parameters : id, pwd
 - data : token
 - 로그인 성공 시 토큰이 발행이 됩니다. 이 토큰은 회원가입을 제외한 다른 기능을 사용할 때 필요한 파라미터입니다.
 - code : 200, 201, 300, 302, 304, 305, 401

3. 탐색 ((개인url)/shutdown/askdb)
 - Parameters : token, building
 - building으로 보낸 건물의 데이터가 있는 지 확인합니다. 있다면 결과를 data로 전송합니다.
 - 탐색을 사용 시 새로운 토큰을 발행합니다. 그 전에 사용하던 토큰은 만료가 됩니다.
 - code : 200, 300, 305
 
4. 종료 ((개인url)/shutdown/turnoff)
 - Parameters : token, location
 - location(강의실이름)을 종료할 때 사용합니다. 해당 강의실에 있는 컴퓨터 종료가 됩니다.
 - 종료를 사용 시 새로운 토큰을 발행합니다. 그 전에 사용하던 토큰은 만료가 됩니다.
 - code : 200, 300, 305

5. 관리자페이지 ((개인url)/admin/adminLoad)
 - Parameters : token
 - 현재 회원가입을 한 회원들의 정보를 받을 수 있습니다.
 - 관리자 페이지 접속 시 새로운 토큰을 발행합니다. 그 전에 사용하던 토큰은 만료가 됩니다.
 - code : 200, 300, 305
 
6. 권한변경 ((개인url)/admin/adminUpdate)
 - Parameters : token, id, level
 - 권한을 변경하고자 하는 id, 권한 레벨으 지정하면 됩니다.
 - 권한변경 시 새로운 토큰을 발행합니다. 그 전에 사용하던 토큰은 만료가 됩니다.
 - code : 200, 300, 305
 
 
<Client(인절미 C#프로그램용)>

7. 등록여부 확인 ((개인url)/client/askExist)
 - Parameters : macAddress
 - 해당 컴퓨터의 맥주소를 받아와 등록된 컴퓨터인지 확인합니다.
 - code : 200, 306 
 
8. 등록 ((개인url)/client/insertAddress)
 - Parameters : macAddress, location
 - 등록여부 확인과 등록하기를 같은 쿼리로 돌릴 수 있었지만 달리한 이유는 C# 프로그램을 간단히 만들기 위함이다.
 - 해당 컴퓨터의 맥주소를 전송받고, location은 해당 컴퓨터의 강의실 위치이다.
 - code : 200, 300, 401
 
9. 상태 업데이트 ((개인url)/client/updateState)
 - Parameters : macAddress, state
 - 인절미가 설치된 컴퓨터가 온라인 상태라면 서버에 주기적으로 현 상태를 전송합니다.
 - code : 200, 300, 401
 
10. 종료 명령 ((개인url)/client/updateShutdown)
 - Parameters : macAddress
 - macAddress에 해당하는 컴퓨터에게 종료명령을 내립니다. 
 - code : 200, 300, 401
 
 
<내 주변지진대피소 API>
 
11. 주변 지진대피소 찾기 ((개인url)/earthquake/eqfind)
 - Parameters : longitude, latitude, distance
 - 경도, 위도를 파라미터로 받고 해당 위치에서 반경 몇키로까지 정보를 받을지 계산하여 데이터를 리턴합니다.
 - 100m = 0.1, 1km = 1, 5km = 5
 - code : 200, 300
  
12. 대피소 상세정보 ((개인url)/earthquake/eqinfo)
 - Parameters : longitude, latitude
 - 경도, 위도에 맞는 대피소의 상세 정보를 찾아 해당 데이터를 리턴합니다.
 - code : 200, 300



