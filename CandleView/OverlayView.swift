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
    let marketCap: Double
    
    var formattedMarketCap: String {
        if marketCap >= 1_000_000_000 {
            return String(format: "$%.2fB", marketCap / 1_000_000_000)
        } else if marketCap >= 1_000_000 {
            return String(format: "$%.2fM", marketCap / 1_000_000)
        } else if marketCap >= 1_000 {
            return String(format: "$%.2fK", marketCap / 1_000)
        } else {
            return String(format: "$%.2f", marketCap)
        }
    }
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
                    let minCap = viewModel.priceHistory.map { $0.marketCap }.min() ?? 0
                    let maxCap = viewModel.priceHistory.map { $0.marketCap }.max() ?? 0
                    // Add 5% padding to the range
                    let range = maxCap - minCap
                    let yMin = max(0, minCap - (range * 0.05))
                    let yMax = maxCap + (range * 0.05)
                    
                    Chart {
                        ForEach(viewModel.priceHistory) { point in
                            LineMark(
                                x: .value("Time", point.time),
                                y: .value("Market Cap", point.marketCap)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(.green)
                            
                            PointMark(
                                x: .value("Time", point.time),
                                y: .value("Market Cap", point.marketCap)
                            )
                            .foregroundStyle(.green)
                        }
                        
                        RuleMark(
                            y: .value("Current", viewModel.priceHistory.last?.marketCap ?? 0)
                        )
                        .foregroundStyle(.gray.opacity(0.5))
                        .lineStyle(StrokeStyle(dash: [5, 5]))
                    }
                    .chartYScale(domain: yMin...yMax)
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            let marketCap = value.as(Double.self) ?? 0
                            AxisValueLabel {
                                if marketCap >= 1_000_000_000 {
                                    Text("\(String(format: "%.1fB", marketCap / 1_000_000_000))")
                                } else if marketCap >= 1_000_000 {
                                    Text("\(String(format: "%.1fM", marketCap / 1_000_000))")
                                } else if marketCap >= 1_000 {
                                    Text("\(String(format: "%.1fK", marketCap / 1_000))")
                                } else {
                                    Text("\(String(format: "%.1f", marketCap))")
                                }
                            }
                            AxisGridLine()
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .minute)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.hour().minute())
                        }
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
                VStack(spacing: 4) {
                    HStack {
                        Text("24h: \(String(format: "%.1f%%", pair.priceChange.h24))")
                            .foregroundColor(pair.priceChange.h24 >= 0 ? .green : .red)
                        Spacer()
                        Text("1h: \(String(format: "%.1f%%", pair.priceChange.h1))")
                            .foregroundColor(pair.priceChange.h1 >= 0 ? .green : .red)
                    }
                    HStack {
                        Text("MCAP: \(pair.formattedMarketCap)")
                        Spacer()
                        Text("VOL: $\(String(format: "%.1fK", pair.volume.h24 / 1000))")
                    }
                    .foregroundColor(.secondary)
                }
                .font(.caption)
            }
        }
        .padding(12)
        .frame(width: 250, height: 200)
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
