## Middlewares

Request interceptors used by the backend:

- `rbacMiddleware.js` — Checks whether the authenticated user has the required role (Nurse, Doctor, or Admin).
- `auditLogger.js` — Automatically logs `POST` and `PUT` requests.
