//
//  StartView.swift
//  Example
//
//  Created by Victor Kostin on 27.11.2024.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: StartViewModel
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Button {
                viewModel.push()
            } label: {
                Text("Open")
            }
        }
    }
}
