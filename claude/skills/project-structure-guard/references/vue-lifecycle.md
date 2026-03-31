# Vue / React 라이프사이클 레퍼런스

## Vue 3 Composition API 라이프사이클

```
컴포넌트 생성
    ↓ setup()
    ↓ onBeforeMount
    ↓ onMounted         ← 데이터 fetch, 이벤트 리스너 등록
    ↓ [사용자 인터랙션 / 데이터 변경]
    ↓ onBeforeUpdate
    ↓ onUpdated
    ↓ onBeforeUnmount   ← 정리 준비
    ↓ onUnmounted       ← 리스너 해제, 타이머 정리, 구독 취소
```

### 올바른 패턴

```vue
<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { useUserStore } from '@/stores/user'

const store = useUserStore()
let timer = null

onMounted(async () => {
  // ✅ 초기 데이터 로드
  await store.fetchUsers()

  // ✅ 이벤트 리스너 등록
  window.addEventListener('resize', handleResize)

  // ✅ 타이머 시작
  timer = setInterval(pollData, 5000)
})

onUnmounted(() => {
  // ✅ 반드시 정리
  window.removeEventListener('resize', handleResize)
  clearInterval(timer)
})
</script>
```

### 위반 패턴

```vue
<script setup>
import { onMounted } from 'vue'

onMounted(() => {
  // ❌ cleanup 없는 이벤트 리스너
  window.addEventListener('keydown', handleKey)

  // ❌ cleanup 없는 타이머
  setInterval(pollData, 5000)

  // ❌ cleanup 없는 WebSocket
  const ws = new WebSocket(url)
  ws.onmessage = handleMessage
})
// onUnmounted 없음 → 메모리 누수
</script>
```

---

## React Hooks 라이프사이클

```
컴포넌트 마운트
    ↓ useEffect(() => { ... }, [])    ← mount (빈 배열)
    ↓ [상태/props 변경]
    ↓ useEffect(() => { ... }, [dep]) ← dep 변경 시
    ↓ 언마운트 시 cleanup 함수 실행
```

### 올바른 패턴

```jsx
import { useEffect, useRef } from 'react'

function MyComponent() {
  const timerRef = useRef(null)

  useEffect(() => {
    // ✅ mount 시 실행
    fetchData()
    window.addEventListener('resize', handleResize)
    timerRef.current = setInterval(pollData, 5000)

    // ✅ cleanup 반드시 반환
    return () => {
      window.removeEventListener('resize', handleResize)
      clearInterval(timerRef.current)
    }
  }, []) // 빈 배열 = mount/unmount만

  return <div>...</div>
}
```

### 위반 패턴

```jsx
useEffect(() => {
  // ❌ cleanup 없음
  window.addEventListener('scroll', handleScroll)
  const subscription = store.subscribe(callback)
  // return 없음 → 메모리 누수
}, [])
```

---

## 프론트엔드 데이터 흐름 규칙

```
[API 응답 수신]
    ↓
[타입/인터페이스로 파싱] (TypeScript interface or Zod schema)
    ↓
[Store / State 저장]
    ↓
[컴포넌트에서 읽기]
    ↓
[폼 제출 시 DTO 객체로 변환 후 전송]
```

### TypeScript 타입 분리

```typescript
// types/user.ts — API 응답 타입
export interface UserResponse {
  id: number
  email: string
  createdAt: string
}

// types/forms.ts — 폼 입력 타입
export interface UserCreateForm {
  email: string
  password: string
  passwordConfirm: string
}

// api/users.ts — API 호출 + 타입 적용
export async function createUser(form: UserCreateForm): Promise<UserResponse> {
  const { data } = await axios.post<UserResponse>('/users', {
    email: form.email,
    password: form.password
  })
  return data
}
```
