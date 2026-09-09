//
//  ContentView.swift
//  currency-exchange-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct ContentView: View {
    @State var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.validateOutput(), id: \.self) { key in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vm.emojiFlag(key))
                                .font(.system(size: 30))
                            
                            Text(vm.countryName(currencyCode: key) ?? key)
                        }
                        
                        Spacer()
                        Text(vm.formatRateForLocale(for: key))
                            .font(.title2)
                            .bold()
                            .shadow(color: .secondary, radius: 3)
                    }
                }
                .listRowSeparator(.hidden)
                .padding()
            }
            .preferredColorScheme(.dark)
            .listStyle(.plain)
            .navigationTitle("Exchange Rates \(vm.formatRateForLocale(for: "EUR"))")
        }
    }
}

#Preview {
    ContentView()
}
