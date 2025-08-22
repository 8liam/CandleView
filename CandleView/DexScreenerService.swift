import Foundation
import Combine

@MainActor
class DexScreenerService: ObservableObject {
    static let shared = DexScreenerService()
    private let baseURL = "https://api.dexscreener.com/tokens/v1"
    
    @Published var currentTokenData: TokenData?
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true
        
        // Add required headers
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "User-Agent": "CandleView/1.0"
        ]
        
        session = URLSession(configuration: config)
    }
    
    func startTracking(contractAddress: String) {
        // Cancel existing timer if any
        timer?.invalidate()
        
        // Initial fetch
        Task {
            await fetchTokenData(contractAddress: contractAddress)
        }
        
        // Set up timer for periodic updates (every 30 seconds)
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchTokenData(contractAddress: contractAddress)
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopTracking() {
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchTokenData(contractAddress: String) async {
        let urlString = "\(baseURL)/solana/\(contractAddress)"
        
        guard let url = URL(string: urlString) else {
            self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                self.error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"])
                return
            }
            
            // Print raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            let tokenData = try decoder.decode(TokenData.self, from: data)
            print("Decoded pairs count: \(tokenData.count)")
            self.currentTokenData = tokenData
            self.error = nil
        } catch let decodingError as DecodingError {
            self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response: \(decodingError.localizedDescription)"])
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
                case .timedOut:
                    self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Request timed out"])
                default:
                    self.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error: \(urlError.localizedDescription)"])
                }
            } else {
                self.error = error
            }
        }
    }
}
