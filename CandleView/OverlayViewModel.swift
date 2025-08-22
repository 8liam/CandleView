import Foundation
import Combine

@MainActor
class OverlayViewModel: ObservableObject {
    @Published var contractAddress: String = ""
    @Published var currentPair: PairData?
    @Published var priceHistory: [PricePoint] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let dexScreenerService = DexScreenerService.shared
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // Create a timer publisher for consistent x-axis time intervals
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                // Update the last price point's time if it exists
                if let lastPrice = self?.currentPair?.priceUsdDouble {
                    let newPoint = PricePoint(
                        time: Date(),
                        price: lastPrice,
                        marketCap: self?.currentPair?.marketCap ?? 0.0
                    )
                    self?.priceHistory.append(newPoint)
                    
                    // Keep last 12 price points (6 minutes of data with 30-second updates)
                    if self?.priceHistory.count ?? 0 > 12 {
                        self?.priceHistory.removeFirst()
                    }
                }
            }
            .store(in: &cancellables)

        dexScreenerService.$currentTokenData
            .receive(on: RunLoop.main)
            .sink { [weak self] tokenData in
                guard let pair = tokenData?.first else { return }
                self?.currentPair = pair
                
                // If this is the first data point, add it immediately
                if self?.priceHistory.isEmpty ?? true {
                    let newPoint = PricePoint(
                        time: Date(),
                        price: pair.priceUsdDouble,
                        marketCap: pair.marketCap ?? 0.0
                    )
                    self?.priceHistory.append(newPoint)
                }
            }
            .store(in: &cancellables)
        
        dexScreenerService.$error
            .receive(on: RunLoop.main)
            .map { error -> String? in
                error?.localizedDescription
            }
            .assign(to: &$errorMessage)
    }
    
    func startTracking() {
        guard !contractAddress.isEmpty else {
            errorMessage = "Please enter a contract address"
            return
        }
        
        dexScreenerService.startTracking(contractAddress: contractAddress)
    }
    
    func stopTracking() {
        dexScreenerService.stopTracking()
    }
}
