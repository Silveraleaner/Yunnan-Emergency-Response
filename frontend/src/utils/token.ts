let _token: string | null = null

export function getStoredToken(): string | null {
  return _token
}

export function setStoredToken(token: string | null): void {
  _token = token
}

export function clearStoredToken(): void {
  _token = null
}