//
//  ContentView.swift
//  AdviceProvider
//
//  Created by Zaid Ragab on 2023-04-20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var currentAdvice: Advice = Advice(slip: Slip(id: 0, advice: ""))
    @State var currentAdviceInFavourites = false
    @State var favourites: [Advice] = []
    
    var body: some View {
        VStack(spacing: 20) {
           
            Text("Need Advice?")
                .font(.title)
                .multilineTextAlignment(.center)
            
            Button(action: {
                Task {
                    await loadNewAdvice()
                }
            }, label: {
                Text("Get Advice")
            })
            
            Text("\"\(currentAdvice.slip.advice)\"")
                .multilineTextAlignment(.center)
            
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(currentAdviceInFavourites ? .red : .secondary)
                .onTapGesture {
                    if !currentAdviceInFavourites {
                        favourites.append(currentAdvice)
                        currentAdviceInFavourites = true
                    }
                }
            List(favourites, id: \.self) { currentAdvice in
                Text(currentAdvice.slip.advice)
            }
          Spacer()
        }
        .task {
            await loadNewAdvice()
            print("I tried to load new advice")
            loadFavourites()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                print("Active")
            } else {
                print("Background")
                persistFavourites()
            }
        }
        .navigationTitle("Get Advice")
        .padding()
    }
    
    func loadNewAdvice() async {
        
        let url = URL(string: "https://api.adviceslip.com/advice")!
        
        var request = URLRequest(url: url)
        
        
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            
            currentAdvice = try JSONDecoder().decode(Advice.self, from: data)
            
            currentAdviceInFavourites = false
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            print(error)
        }
    }
    
    func persistFavourites() {
        
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        
        print(filename)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(favourites)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("Saved the data to the Documents directory successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print("Unable to write list of favourites to the Documents directory")
            print("==========")
            print(error.localizedDescription)
        }
    }
    
    func loadFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
        do {
            let data = try Data(contentsOf: filename)
            print("Saved data to the Documents directory successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
            favourites = try JSONDecoder().decode([Advice].self, from: data)
        } catch {
            print("Could not load the data from the stored JSON file")
            print("==========")
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
