# CandleView

A macOS menu bar application for real-time tracking of token prices using the DexScreener API.

## Features

- Real-time token price tracking
- Live price chart with 6-minute history
- Market cap display
- 24-hour price change indicators
- Floating overlay window
- Automatic 30-second updates

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.0 or later

## Installation

1. Clone the repository
```bash
git clone https://github.com/YourUsername/CandleView.git
```

2. Open the project in Xcode
```bash
cd CandleView
open CandleView.xcodeproj
```

3. Build and run the project (⌘R)

## Usage

1. Launch the app
2. Enter a token contract address in the main window
3. Click "Track" to start monitoring
4. The overlay window will show real-time price updates
5. Double-click the overlay to move it around

## Architecture

- SwiftUI for the user interface
- Combine for reactive data handling
- MVVM architecture pattern
- DexScreener API integration

## API Reference

The app uses the DexScreener API for token data:
- Base URL: `https://api.dexscreener.com/latest/dex/search`
- Documentation: [DexScreener API](https://docs.dexscreener.com/api/reference)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
