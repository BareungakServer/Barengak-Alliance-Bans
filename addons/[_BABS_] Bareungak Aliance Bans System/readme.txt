운영|UI 디자인:바른각|http://steamcommunity.com/id/SPStudio/
개발:lill74|http://steamcommunity.com/id/0F0539842EFC/
부계정 차단기능 개발:젤렌|http://steamcommunity.com/id/_jellen/|https://github.com/un5450/subaccountban_mugagum/blob/master/lua/autorun/SubAccBan.lua


에드온 폴더속 lua\autorun\server\sv_init.lua 파일 속 스팀API를 직접 입력해주셔야 부계정 차단 기능을 사용하실수 있습니다.
	https://steamcommunity.com/dev/apikey <-- 이곳에서 발급받아 큰따옴표 사이에 복사해주세요 

기본 명령어 (모두 콘솔 "~" 키를 눌러서 입력해주세요)
    babs_getlist : 서버에 캐쉬된 연합벤 목록을 봅니다.
    babs_getversion : 에드온의 현재 최신버전과 서버에 설치된 에드온의 버전을 보여줍니다.
    babs_aliban_update : 수동으로 데이터베이스를 업데이트시킵니다.

유저가 차단된뒤 뜨는 서버 콘솔에 뜨는 에러는 정상입니다.