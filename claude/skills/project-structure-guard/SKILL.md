---
name: project-structure-guard
description: >
  프로젝트 구조 규칙을 강제하는 훈련교관 스킬. 코드 작성, 파일 생성, 기능 구현, DB/API 설계, 리팩토링 등 모든 개발 작업에서 반드시 이 스킬을 사용해야 한다.
  위반 발견 즉시 작업을 중단하고 먼저 지적한다. 다음 키워드에 무조건 트리거:
  "코드 짜줘", "구현해줘", "파일 만들어", "API 만들어", "스키마", "모델", "서비스", "컨트롤러", "미들웨어",
  "공통화", "리팩토링", "새 기능", "추가해줘", "수정해줘", "라이프사이클", "startup", "shutdown", "Vue", "React", "FastAPI".
  개발 작업이라면 예외 없이 이 스킬을 먼저 적용한다.
---

# 🪖 Project Structure Guard — 훈련교관

> **원칙: 규칙 위반을 발견하면 즉시 작업을 멈추고 지적한다. 위반 위에 코드를 쌓지 않는다.**

---

## ⚠️ 교관의 작동 방식

코드 작업 요청을 받으면 다음 순서로 반드시 실행한다:

1. **INSPECT** — 요청된 작업이 어느 규칙에 해당하는지 파악
2. **AUDIT** — 기존 코드/구조에 위반 사항이 있는지 먼저 점검
3. **BLOCK** — 위반 발견 시 작업 중단, 위반 내용 명시적으로 고지
4. **FIX OR PROCEED** — 위반 수정 후 또는 위반 없음 확인 후 진행
5. **SUGGEST** — 공통화 가능한 부분 발견 시 작업 완료 후 추천

---

## 📋 규칙 목록

### RULE-01: 라이프사이클 준수

앱 시작/종료 시 반드시 처리해야 할 것들을 라이프사이클 훅에 구현해야 한다.

**FastAPI 기준:**
```python
# ✅ 올바른 방식
@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup: DB 연결, 캐시 초기화, 설정 로드
    await database.connect()
    yield
    # shutdown: 연결 해제, 리소스 정리
    await database.disconnect()

app = FastAPI(lifespan=lifespan)
```

**Vue/React 기준:**
- `onMounted` / `useEffect(()=>{}, [])` — 초기 데이터 로드, 이벤트 리스너 등록
- `onUnmounted` / `useEffect cleanup` — 이벤트 리스너 해제, 타이머 정리, 구독 취소

**위반 패턴:**
- ❌ startup/shutdown 훅 없이 전역 변수로 DB 연결
- ❌ 컴포넌트 unmount 시 cleanup 없는 이벤트 리스너/타이머
- ❌ lifespan 대신 deprecated `on_event("startup")` 사용

---

### RULE-02: 데이터 흐름 규칙

데이터는 반드시 정해진 흐름을 따른다. 어느 단계에서도 흐름을 건너뛰지 않는다.

```
[요청 진입]
    ↓
[Controller] Pydantic 모델로 validation & 수신
    ↓
[Service] 비즈니스 로직 처리, DB는 SQLAlchemy Schema(ORM)로
    ↓
[Service → Controller] 결과를 Pydantic 모델로 파싱
    ↓
[응답 출력] JSON으로 직렬화
```

**각 레이어 책임:**

| 레이어 | 받는 형태 | 내보내는 형태 |
|--------|-----------|--------------|
| Controller (Router) | HTTP Request → Pydantic Model | Pydantic Model → JSON Response |
| Service | Pydantic Model | SQLAlchemy Schema (DB 작업), Pydantic Model (반환) |
| Repository | SQLAlchemy Schema | SQLAlchemy Schema |

**위반 패턴:**
- ❌ Controller에서 raw dict로 데이터 처리
- ❌ Service에서 직접 JSON 직렬화
- ❌ Repository에서 Pydantic 모델 사용
- ❌ 응답에 ORM 객체 그대로 반환
- ❌ `response.dict()` 없이 ORM 객체를 JSON으로

---

### RULE-03: 인증은 미들웨어가 아니다

인증/인가 처리 위치 규칙.

**올바른 위치:**
```python
# ✅ Dependency Injection으로 처리
async def get_current_user(token: str = Depends(oauth2_scheme)):
    ...

@router.get("/protected")
async def protected_route(user: User = Depends(get_current_user)):
    ...
```

**위반 패턴:**
- ❌ `app.add_middleware(AuthMiddleware)` — 인증을 미들웨어로 처리
- ❌ 모든 라우트에 미들웨어가 인증을 주입하는 구조
- ⚠️ 미들웨어는 로깅, CORS, 요청 ID 부여 등 횡단 관심사에만 사용

---

### RULE-04: Pydantic + Schema + Mapper 유기적 연동

3가지가 반드시 각자의 역할로 존재해야 한다.

```python
# 📁 app/models/user.py — Pydantic (validation + API I/O)
class UserCreate(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    email: str
    class Config:
        from_attributes = True

# 📁 app/schemas/user.py — SQLAlchemy (DB 영속성)
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    hashed_password = Column(String)

# 📁 app/mappers/user.py — 변환 책임
def to_schema(model: UserCreate, hashed_pw: str) -> User:
    return User(email=model.email, hashed_password=hashed_pw)

def to_response(schema: User) -> UserResponse:
    return UserResponse.model_validate(schema)
```

**위반 패턴:**
- ❌ Pydantic 모델을 DB ORM으로도 사용 (역할 혼용)
- ❌ Service에서 직접 `User(email=data["email"])` dict 접근
- ❌ mapper 없이 Controller에서 직접 ORM → Pydantic 변환

---

### RULE-05: app / core 영역 분리

```
project/
├── app/                    # 비즈니스 도메인별 기능
│   ├── {domain}/
│   │   ├── router.py
│   │   ├── service.py
│   │   ├── models.py       # Pydantic
│   │   ├── schemas.py      # SQLAlchemy
│   │   └── mapper.py
│   └── ...
├── core/                   # 공통 인프라 (절대 domain 코드 포함 금지)
│   ├── config.py           # 설정
│   ├── database.py         # DB 연결
│   ├── security.py         # 암호화, 토큰
│   ├── exceptions.py       # 공통 예외
│   ├── dependencies.py     # 공통 Depends
│   └── lifespan.py         # 앱 라이프사이클
└── shared/                 # 재사용 유틸리티
    ├── pagination.py
    ├── response.py         # 공통 응답 포맷
    └── validators.py
```

**위반 패턴:**
- ❌ `core/` 안에 특정 도메인 비즈니스 로직
- ❌ `app/` 안에 DB 연결, 설정 로직
- ❌ 같은 유틸 함수가 여러 도메인에 복붙

---

### RULE-06: AI 코딩 시 공통 영역 보호 (최고 우선순위)

**이 규칙은 다른 모든 규칙보다 우선한다.**

- ❌ `core/`, `shared/` 파일을 임의로 수정하지 않는다
- ❌ 요청 주제와 관련 없는 공통 함수를 추가/삭제하지 않는다
- ❌ 기존 공통 인터페이스(함수 시그니처, 반환 타입)를 바꾸지 않는다
- ✅ 공통화할 수 있는 코드를 발견하면 **작업 완료 후 추천만** 한다

**추천 포맷 예시:**
```
💡 공통화 추천:
  - `app/auth/service.py`의 `paginate()` 로직이 `app/assets/service.py`와 동일합니다.
  - `shared/pagination.py`로 추출을 권장합니다. 진행할까요?
```

---

## 🔍 작업 전 체크리스트

모든 코드 작업 전 내부적으로 다음을 확인한다:

```
[ ] RULE-01: 라이프사이클 훅이 올바른 위치에 있는가?
[ ] RULE-02: 데이터가 Controller→Service→DB→Service→JSON 흐름을 따르는가?
[ ] RULE-03: 인증이 미들웨어가 아닌 Dependency로 처리되는가?
[ ] RULE-04: Pydantic 모델 / SQLAlchemy 스키마 / Mapper가 분리되어 있는가?
[ ] RULE-05: app/core/shared 영역이 올바르게 분리되어 있는가?
[ ] RULE-06: core/shared 영역을 건드리지 않는가?
```

위반 항목 발견 시 → **즉시 작업 중단 + 위반 내용 고지 + 수정 방향 제시**

---

## 🗣️ 교관 응답 포맷

### 위반 발견 시:
```
🚨 RULE-{번호} 위반 감지 — 작업 중단

위반 내용: [구체적으로 무엇이 잘못됐는지]
위반 위치: [파일명 또는 코드 위치]
올바른 방향: [어떻게 수정해야 하는지]

수정 후 진행하겠습니다. 먼저 수정하시겠습니까, 아니면 제가 수정안을 제시할까요?
```

### 위반 없이 진행 시:
```
✅ 구조 검토 완료 — 규칙 준수 확인
[작업 진행]
```

### 작업 완료 후 공통화 추천 시:
```
💡 공통화 추천 (선택사항):
[추천 내용]
진행할까요?
```

---

자세한 스택별 레퍼런스는 `references/` 디렉토리를 참조:
- `references/fastapi-patterns.md` — FastAPI 구체 패턴
- `references/vue-lifecycle.md` — Vue 컴포넌트 라이프사이클
