# NITV EVENTS (iOS · Swift · UIKit, programmatic UI · MVVM + Clean Architecture)

Open `NITVEvents.xcodeproj` in **Xcode 26**, pick your Team under *Signing & Capabilities*, and run on an iPhone (iOS 16+).
No storyboards or XIBs - every screen is built in code. The project uses Xcode's folder-synchronised group, so any `.swift` file you add inside `NITVEvents/` is picked up automatically.

## Flow
Splash -> Login (email + password) -> Main tab bar: **Home** | **Ticket**
- **Home**: Pension Patta poster card with details below + floating **Scan me** button (camera QR / barcode scanner; the scanned value is put into the Ticket search).
- **Ticket**: search field (name / ticket ID / phone), debounced, results as cards; tapping a card opens a `WKWebView`.

## Architecture
```
NITVEvents/
├── Core/           AppConfig (BASE_URL, mock switch), Resource
├── Domain/         Models, repository protocols, use cases (LoginUseCase, SearchTicketsUseCase)
├── Data/           APIService (Remote + Mock), DTOs, Keychain TokenStorage, repository impls
├── DI/             AppContainer (manual dependency injection)
├── Presentation/   Common (Theme, AppRouter), Splash, Login, Main, Home, Ticket, WebView, Scanner
│                   ViewControllers + ViewModels (Combine @Published state)
└── Assets.xcassets App icon, NITV logo, poster
```

## Connect your real backend
In `Core/AppConfig.swift`:
```swift
static let baseURL = URL(string: "https://your-api.com/v1/")!
static let useMockAPI = false
```
Endpoints are in `Data/Remote/APIService.swift`.

**POST `auth/login`** body `{"email": "...", "password": "..."}`
-> 200 `{"message": "...", "token": "...", "user": {"id": "", "name": "", "email": ""}}`
-> non-2xx `{"message": "Invalid email or password"}` (shown on the login screen)

**GET `tickets/search?q=<text>`**
-> `{"data": [{"ticket_id": "NT-1001", "name": "...", "phone": "...", "event": "...", "show": "...", "status": "...", "view_url": "https://..."}]}`
`view_url` is opened in the WebView (falls back to `{baseURL}tickets/view/{ticket_id}`).

The token is stored in the Keychain and sent as `Authorization: Bearer <token>`.

## Mock mode (default)
With `useMockAPI = true`, any valid email + password of 6+ characters logs in, and the Ticket tab searches 5 sample tickets (try "Ram", "NT-1002", "0901").

## Notes
- Splash always goes to Login (as requested). To skip login when a token exists, check `TokenStorage().getToken()` in `AppRouter.showSplash`.
- The scanner needs a real device (no camera in the Simulator). The camera permission text is in `Info.plist`.
- The UI is forced to light mode (`SceneDelegate`) because the design is light-only.
- Bundle ID is `com.nitv.events` - change it in the target settings.
