//
//  ContentView.swift
//  CandleView
//
//  Created by liam on 19/8/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: OverlayViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Memecoin Tracker")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Contract Address")
                    .font(.headline)
                
                HStack {
                    TextField("Enter contract address", text: $viewModel.contractAddress)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Track") {
                        viewModel.startTracking()
                    }
                    .disabled(viewModel.contractAddress.isEmpty)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Features:")
                    .font(.headline)
                Text("• Real-time price updates")
                Text("• 24h price change")
                Text("• Price chart")
            }
            .padding()
            
            Spacer()
        }
        .frame(width: 400, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: OverlayViewModel())
    }
}