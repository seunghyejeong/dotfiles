# FastAPI 구조 패턴 레퍼런스

## 디렉토리 구조 전체 예시

```
project/
├── main.py
├── core/
│   ├── config.py
│   ├── database.py
│   ├── security.py
│   ├── exceptions.py
│   ├── dependencies.py
│   └── lifespan.py
├── shared/
│   ├── pagination.py
│   ├── response.py
│   └── validators.py
└── app/
    ├── users/
    │   ├── router.py
    │   ├── service.py
    │   ├── models.py      # Pydantic
    │   ├── schemas.py     # SQLAlchemy ORM
    │   └── mapper.py
    └── assets/
        ├── router.py
        ├── service.py
        ├── models.py
        ├── schemas.py
        └── mapper.py
```

## Lifespan 패턴

```python
# core/lifespan.py
from contextlib import asynccontextmanager
from fastapi import FastAPI
from core.database import database

@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    await database.connect()
    print("DB connected")
    yield
    # shutdown
    await database.disconnect()
    print("DB disconnected")
```

```python
# main.py
from core.lifespan import lifespan

app = FastAPI(lifespan=lifespan)
```

## Controller (Router) 패턴

```python
# app/users/router.py
from fastapi import APIRouter, Depends
from app.users.models import UserCreate, UserResponse
from app.users.service import UserService
from core.dependencies import get_current_user

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=UserResponse)
async def create_user(
    body: UserCreate,           # Pydantic으로 수신
    service: UserService = Depends()
):
    return await service.create(body)  # Pydantic 모델 전달
```

## Service 패턴

```python
# app/users/service.py
from app.users.models import UserCreate, UserResponse
from app.users.schemas import User
from app.users.mapper import to_schema, to_response
from core.database import database

class UserService:
    async def create(self, data: UserCreate) -> UserResponse:
        # Pydantic → SQLAlchemy Schema
        user_schema = to_schema(data)

        # DB 작업은 Schema로
        async with database.transaction():
            db_user = await database.execute(
                User.__table__.insert().values(**user_schema.__dict__)
            )

        # Schema → Pydantic 모델로 반환
        return to_response(db_user)
```

## Mapper 패턴

```python
# app/users/mapper.py
from app.users.models import UserCreate, UserResponse
from app.users.schemas import User
from core.security import hash_password

def to_schema(model: UserCreate) -> User:
    return User(
        email=model.email,
        hashed_password=hash_password(model.password)
    )

def to_response(schema: User) -> UserResponse:
    return UserResponse.model_validate(schema)
```

## Dependency Injection 인증 패턴

```python
# core/dependencies.py
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from core.security import decode_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")

async def get_current_user(token: str = Depends(oauth2_scheme)):
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
    return payload
```

## 공통 응답 포맷

```python
# shared/response.py
from pydantic import BaseModel
from typing import TypeVar, Generic, Optional

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    success: bool
    data: Optional[T] = None
    message: Optional[str] = None

# 사용
@router.get("/", response_model=ApiResponse[list[UserResponse]])
async def list_users():
    users = await service.list()
    return ApiResponse(success=True, data=users)
```
