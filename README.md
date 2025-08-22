# CandleView

A macOS application for real-time tracking of Solana token market caps and prices using the DexScreener API.

<img width="1680" height="1047" alt="Screenshot 2025-08-22 at 10 48 08 am" src="https://github.com/user-attachments/assets/b69196f8-1b01-44f9-a661-fcb3d663091c" />

## Features

- Real-time token market cap and price tracking
- Live chart with dynamic scaling
- 24h and 1h price change indicators
- Volume and market cap display
- Floating overlay window with automatic updates
- 30-second refresh interval
- Minimalist dark mode interface

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
2. Enter a Solana token contract address in the main window
3. Click "Track" to start monitoring
4. The overlay window will display:
   - Current price
   - Market cap chart
   - 24h and 1h price changes
   - Market cap value
5. The chart automatically scales to show price movements clearly
6. Data refreshes every 30 seconds automatically

## Architecture

- SwiftUI for the user interface
- Combine for reactive data handling
- MVVM architecture pattern
- Async/await for network operations
- DexScreener API integration

## API Reference

The app uses the DexScreener API for token data:
- Base URL: `https://api.dexscreener.com/tokens/v1`
- Endpoint: `/solana/{tokenAddress}`
- Example: `https://api.dexscreener.com/tokens/v1/solana/G7yFuzP3WyUY3VdgMDo27dAYSBD5gqxwaARPczzmpump`

## Features in Detail

### Chart
- Dynamic Y-axis scaling for better visibility of price movements
- Automatic range adjustment with 5% padding
- Grid lines for easy value reading
- Current value indicator line

### Market Data
- Real-time price updates
- Market cap tracking
- 24h and 1h price change indicators
- Color-coded positive/negative changes

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
