# Crossword Game

An interactive crossword puzzle game built with Flutter. Draw lines to connect letters and form words!

## Features

- Interactive crossword puzzle interface
- Touch/drag to draw lines between letters
- Word validation and feedback
- Responsive design for web and mobile

## Getting Started

### Prerequisites

- Flutter SDK (managed via FVM)
- FVM (Flutter Version Management)

### Local Development

1. Clone the repository
2. Install dependencies:
   ```bash
   fvm flutter pub get
   ```
3. Run the app:
   ```bash
   fvm flutter run -d web-server --web-port 8080
   ```

### Building for Web

To build the web version:

```bash
fvm flutter build web --release --base-href "/crossword_game/"
```

## Deployment

This project is configured for automatic deployment to GitHub Pages using GitHub Actions.

### Manual Deployment

If you need to deploy manually:

1. Build the web app:
   ```bash
   fvm flutter build web --release --base-href "/crossword_game/"
   ```
2. The built files will be in the `build/web` directory
3. Deploy the contents of `build/web` to your web server

## Project Structure

- `lib/main.dart` - Main application entry point
- `lib/crossword.dart` - Crossword game logic and UI
- `lib/crossword_painter.dart` - Custom painter for drawing lines
- `web/` - Web-specific configuration and assets
- `.github/workflows/deploy.yml` - GitHub Actions deployment workflow

## Technologies Used

- Flutter 3.24.0
- Dart
- Custom painting for interactive line drawing
- GitHub Actions for CI/CD
- GitHub Pages for hosting
