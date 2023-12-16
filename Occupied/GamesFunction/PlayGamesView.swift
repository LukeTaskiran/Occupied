//
//  ContentView.swift
//  TicTacToe
//
//

import SwiftUI

struct PlayGamesView: View {
    @StateObject private var viewModel = TicTacToeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Select AI level")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .padding()
                    
                    Picker("Select AI level", selection: $viewModel.selectedAILevel) {
                        ForEach(viewModel.aiLevelOptions, id: \.self) {
                            Text($0.message)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    Text("Starts with")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .padding()
                    
                    Picker("Starts with", selection: $viewModel.initialPlayer) {
                        ForEach(viewModel.playerOptions, id: \.self) {
                            Text($0.symbol.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    
                    Text(viewModel.turnMessage)
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.brown)
                    
                    BoardView(viewModel: viewModel)
                    
                    Spacer()
                }.navigationTitle(Text("Tic Tac Toe"))
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                viewModel.refreshBoard()
                            }, label: {
                                Text("Refresh")
                            })
                        }
                    }
            }.alert(isPresented: $viewModel.showAlert) {
                Alert( title: Text(viewModel.titleMessage), dismissButton: .default(Text("Close")) {
                    viewModel.refreshBoard()
                })
            }
            }
     }
}

