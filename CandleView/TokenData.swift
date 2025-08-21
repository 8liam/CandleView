import Foundation

struct TokenData: Codable {
    let pairs: [PairData]
}

struct PairData: Codable, Identifiable {
    let id: String // DexScreener uses pairAddress as unique identifier
    let chainId: String
    let dexId: String
    let url: String
    let pairAddress: String
    let baseToken: Token
    let quoteToken: Token
    let priceNative: String
    let priceUsd: String
    let txns: Transactions
    let volume: Volume
    let priceChange: PriceChange
    let liquidity: Liquidity
    let fdv: Double?
    let marketCap: Double?
    let pairCreatedAt: Int64
    let info: TokenInfo?
    
    private enum CodingKeys: String, CodingKey {
        case chainId, dexId, url, baseToken, quoteToken
        case priceNative, priceUsd, txns, volume, priceChange
        case pairAddress, liquidity, fdv, marketCap, pairCreatedAt, info
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chainId = try container.decode(String.self, forKey: .chainId)
        dexId = try container.decode(String.self, forKey: .dexId)
        url = try container.decode(String.self, forKey: .url)
        pairAddress = try container.decode(String.self, forKey: .pairAddress)
        baseToken = try container.decode(Token.self, forKey: .baseToken)
        quoteToken = try container.decode(Token.self, forKey: .quoteToken)
        priceNative = try container.decode(String.self, forKey: .priceNative)
        priceUsd = try container.decode(String.self, forKey: .priceUsd)
        txns = try container.decode(Transactions.self, forKey: .txns)
        volume = try container.decode(Volume.self, forKey: .volume)
        priceChange = try container.decode(PriceChange.self, forKey: .priceChange)
        liquidity = try container.decode(Liquidity.self, forKey: .liquidity)
        fdv = try container.decodeIfPresent(Double.self, forKey: .fdv)
        marketCap = try container.decodeIfPresent(Double.self, forKey: .marketCap)
        pairCreatedAt = try container.decode(Int64.self, forKey: .pairCreatedAt)
        info = try container.decodeIfPresent(TokenInfo.self, forKey: .info)
        id = pairAddress
    }
    
    struct Token: Codable {
        let address: String
        let name: String
        let symbol: String
    }
    
    struct Transactions: Codable {
        let m5: TransactionData?
        let h1: TransactionData?
        let h6: TransactionData?
        let h24: TransactionData
        
        struct TransactionData: Codable {
            let buys: Int
            let sells: Int
        }
    }
    
    struct Volume: Codable {
        let h24: Double
        let h6: Double?
        let h1: Double?
        let m5: Double?
    }
    
    struct PriceChange: Codable {
        let m5: Double?
        let h1: Double?
        let h6: Double?
        let h24: Double
    }
    
    struct Liquidity: Codable {
        let usd: Double
        let base: Double
        let quote: Double
    }
    
    struct TokenInfo: Codable {
        let imageUrl: String?
        let header: String?
        let openGraph: String?
        let websites: [Website]?
        let socials: [Social]?
        
        struct Website: Codable {
            let label: String
            let url: String
        }
        
        struct Social: Codable {
            let type: String
            let url: String
        }
    }
}

extension PairData {
    var priceUsdDouble: Double {
        Double(priceUsd) ?? 0.0
    }
    
    var formattedPriceUsd: String {
        let price = priceUsdDouble
        if price < 0.01 {
            return String(format: "$%.8f", price)
        } else {
            return String(format: "$%.2f", price)
        }
    }
    
    var formattedMarketCap: String {
        guard let mcap = marketCap else { return "N/A" }
        if mcap >= 1_000_000_000 {
            return String(format: "$%.2fB", mcap / 1_000_000_000)
        } else if mcap >= 1_000_000 {
            return String(format: "$%.2fM", mcap / 1_000_000)
        } else if mcap >= 1_000 {
            return String(format: "$%.2fK", mcap / 1_000)
        } else {
            return String(format: "$%.2f", mcap)
        }
    }
}