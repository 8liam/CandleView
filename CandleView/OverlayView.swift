//
//  OverlayView.swift
//  CandleView
//
//  Created by liam on 19/8/2025.
//

import SwiftUI
import Charts

// MARK: - Model
struct PricePoint: Identifiable {
    let id = UUID()
    let time: Date
    let price: Double
}

// MARK: - Overlay Content
struct OverlayView: View {
    @ObservedObject var viewModel: OverlayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Token name + price
            HStack {
                Text(viewModel.currentPair?.baseToken.symbol ?? "No Token Selected")
                    .font(.headline)
                Spacer()
                Text(viewModel.currentPair?.formattedPriceUsd ?? "$0.00")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            // Chart
            Group {
                if !viewModel.priceHistory.isEmpty {
                    Chart {
                        ForEach(viewModel.priceHistory) { point in
                            LineMark(
                                x: .value("Time", point.time),
                                y: .value("Price", point.price)
                            )
                        }
                        .foregroundStyle(.green)
                    }
                    .frame(height: 100)
                } else {
                    Text("Waiting for price data...")
                        .foregroundColor(.secondary)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Stats
            if let pair = viewModel.currentPair {
                HStack {
                    Text("24h: \(String(format: "%.1f%%", pair.priceChange.h24))")
                        .foregroundColor(pair.priceChange.h24 >= 0 ? .green : .red)
                    Spacer()
                    Text("MCAP: \(pair.formattedMarketCap)")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
            }
        }
        .padding(12)
        .frame(width: 250, height: 160)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(radius: 10)
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: String
}
