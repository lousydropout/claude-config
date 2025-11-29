# Next.js Notes

Persistent knowledge for working with Next.js (App Router). Update as we learn.

## App Router Conventions

### File structure
```
app/
  layout.tsx        # Root layout (required)
  page.tsx          # Home page (/)
  globals.css       # Global styles
  
  about/
    page.tsx        # /about
    
  blog/
    page.tsx        # /blog
    [slug]/
      page.tsx      # /blog/:slug
      
  api/
    route.ts        # API route
```

### Special files
- `layout.tsx` — Shared UI, preserves state
- `page.tsx` — Unique UI for route
- `loading.tsx` — Loading UI
- `error.tsx` — Error boundary
- `not-found.tsx` — 404 UI
- `route.ts` — API endpoint

## Server vs Client Components

### Server Components (default)
- Can use async/await directly
- Can access backend resources
- Cannot use hooks, browser APIs, or event handlers

### Client Components
- Add `"use client"` at top of file
- Can use hooks, state, effects
- Can use browser APIs
- Can handle events

### Pattern
```tsx
// ServerComponent.tsx (no directive needed)
import ClientComponent from './ClientComponent'

export default async function ServerComponent() {
  const data = await fetchData()
  return <ClientComponent data={data} />
}

// ClientComponent.tsx
"use client"
export default function ClientComponent({ data }) {
  const [state, setState] = useState(data)
  // ...
}
```

## Common Build Errors

### "use client" issues
- Error: `useState` in server component
- Fix: Add `"use client"` directive

### Import errors
- Error: Importing server-only code in client component
- Fix: Move data fetching to server component, pass as props

### Hydration mismatch
- Error: Server/client HTML doesn't match
- Fix: Ensure consistent rendering, check for `typeof window`

## TypeScript

### Page props
```tsx
type Props = {
  params: { slug: string }
  searchParams: { [key: string]: string | string[] | undefined }
}

export default function Page({ params, searchParams }: Props) {
  // ...
}
```

### Metadata
```tsx
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Page Title',
  description: 'Page description',
}
```

## Lessons Learned

<!-- [YYYY-MM-DD] Observation -->
