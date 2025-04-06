# The Lost City  
Interactive word-guessing game built with Flutter  

<div align="center">
  <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
    <img src="assets/Screenshot1.png" width="280">
    <img src="assets/Screenshot2.png" width="280">
  </div>
</div>

---

## Project Purpose  
A mobile game designed to educate users about world cities through an engaging experience. Key features:  
- Guess city names letter-by-letter  
- Discover cultural and geographical facts  
- Save unlocked cities to a personal collection  

---

## Technical Stack  
- **Framework:** Flutter 3.16 (Dart 3.0)  
- **Core Packages:**  
  - `audioplayers` for sound effects  
  - `http` for API integration  
  - `provider` for state management  
- **Data Sources:**  
  - 100+ cities across 6 continents  
  - MockAPI for dynamic configurations  
- **Architecture:** Layered (UI-Business-Data)  

### API Integration
- **Dynamic Logo:**  
  App Drawer logo is fetched from [MockAPI](https://mockapi.io) endpoint:  
  `GET https://67f0187d2a80b06b8896e4aa.mockapi.io/settings/1`  
  - Returns JSON with `logoUrl` field containing image URL  
  - Fallback to local asset if API fails

---

## Key Features  
### Game Mechanics  
- 6-attempt guessing system with live feedback  
- Dynamic scoring (+5 points per correct letter)  
- Color-coded letter status indicators  

### User Experience  
- Context-sensitive sound effects  
- One-tap audio toggle  
- API-driven dynamic logo  

### Data Management  
- **User Authentication:**  
  - Credentials stored in runtime memory using in-memory Map  
  - No persistent storage for security  
  - Unique username validation  
- City Collections:  
  - Save unlocked cities with descriptions  
  - Detailed city information cards  

---

## Development Team  
| Name                  | Responsibilities                                        |
|-----------------------|---------------------------------------------------------|
| Sumia Abiden          | App Drawer, Home Page, Game Logic and coding            |
| Mariam Kaibalieva     | API integration, Login Page, Game Logic and coding      |

---

## Unique Features  
1. **Educational Content**  
   Curated historical and cultural facts for each city.  

2. **Dynamic Customization**  
   - Theme-aware UI adjustments  
   - Location-based city suggestions  

3. **Progress Tracking**  
   - Real-time score updates  

---

<div align="center">
  <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
    <img src="assets/Screenshot5.png" width="280">
    <img src="assets/Screenshot3.png" width="280">
    <img src="assets/Screenshot4.png" width="280">
  </div>
</div>

## Installation  
1. **Prerequisites:**  
   - Flutter SDK 3.16+  
   - Android Studio or Xcode  

2. **Terminal Commands:**  
```bash
git clone https://github.com/SumiaAbiden/The_Lost_City.git
cd The_Lost_City
flutter pub get
flutter run
