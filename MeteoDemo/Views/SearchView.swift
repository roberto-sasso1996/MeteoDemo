//
//  SearchView.swift
//  MeteoDemo
//
//  Created by Christian Soriani on 19/10/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var showSearchPage: Bool
    @State private var searchText: String = ""
    @State private var selectedItem: City? = nil
    @State private var cities: [City] = []
    @State private var isLoading: Bool = true
    var cityManager = CityManager()
    var onCitySelected: (City) -> Void

    var filteredItems: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.nome.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Cerca comune...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        showSearchPage = false
                    }) {
                        Text("Annulla")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }

                if isLoading {
                    ProgressView("Caricamento comuni...")
                        .padding()
                } else {
                    List(filteredItems, id: \.id) { item in
                        Text(item.nome)
                            .onTapGesture {
                                selectedItem = item
                                handleItemClick(item)
                            }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .navigationTitle("Ricerca Comune")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await fetchCities() // Carica le città quando la vista appare
                }
            }
        }
    }

    func fetchCities() async {
        isLoading = true
        if let cachedCities = getCachedCities() {
            // Se ci sono città nella cache, utilizzale
            cities = cachedCities
            isLoading = false
        } else {
            // Altrimenti, carica da API
            do {
                cities = try await cityManager.getCities()
                cacheCities(cities) // Cache i nuovi comuni
            } catch {
                print("Errore nel caricamento delle città: \(error)")
                cities = []
            }
            isLoading = false
        }
    }

    // Funzioni per la cache
    func cacheCities(_ cities: [City]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "cachedCities")
        }
    }

    func getCachedCities() -> [City]? {
        if let savedCitiesData = UserDefaults.standard.data(forKey: "cachedCities") {
            let decoder = JSONDecoder()
            if let loadedCities = try? decoder.decode([City].self, from: savedCitiesData) {
                return loadedCities
            }
        }
        return nil
    }

    func handleItemClick(_ item: City) {
        onCitySelected(item)
        showSearchPage = false
    }
}


struct SearchView_Previews: PreviewProvider {
    @State static var showSearchPage = true
    
    static var previews: some View {
        SearchView(showSearchPage: $showSearchPage, onCitySelected: { _ in })
    }
}
