//
//  SearchView.swift
//  MeteoDemo
//
//  Created by Christian Soriani on 18/10/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var showSearchPage: Bool
    @State private var searchText: String = "" // Testo della barra di ricerca
    @State private var selectedItem: String? = nil // Variabile per l'elemento selezionato
    @State private var comuni: [String] = [] // Stato per la lista dei comuni
    @State private var isLoading: Bool = true // Stato per gestire il caricamento
        
    var cityManager = CityManager()
    // Closure che invia la città selezionata alla vista chiamante
    var onCitySelected: (String) -> Void
    
    // Computed property per filtrare gli elementi
    var filteredItems: [String] {
        if searchText.isEmpty {
            return comuni // Mostra tutti gli elementi se non c'è testo di ricerca
        } else {
            return comuni.filter { $0.localizedCaseInsensitiveContains(searchText) } // Filtra in base al testo
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra di ricerca
                HStack {
                    TextField("Cerca qualcosa...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Stile della barra di ricerca
                        .padding()
                    
                    // Pulsante per chiudere la pagina
                    Button(action: {
                        showSearchPage = false // Chiude la pagina di ricerca
                    }) {
                        Text("Annulla")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                
                if isLoading {
                    // Mostra una barra di caricamento quando i dati sono in fase di caricamento
                    ProgressView("Caricamento comuni...")
                        .padding()
                } else {
                    // Lista filtrata con gestione clic
                    List(filteredItems, id: \.self) { item in
                        Text(item)
                            .onTapGesture {
                                selectedItem = item
                                handleItemClick(item)
                            }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer() // Riempie lo spazio rimanente
            }
            .navigationTitle("Ricerca")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await fetchComuni() // Carica i comuni quando la vista appare
                }
            }
        }
    }
    
    // Funzione asincrona per caricare la lista di comuni da un'API
    func fetchComuni() async {
        isLoading = true
        if let cachedCities = getCachedCities() {
            // Se ci sono città nella cache, utilizzale
            cities = cachedCities
            isLoading = false
        } else {
            // Altrimenti, carica da API
            do {
                cities = try await getCityList()
                cacheCities(cities) // Cache i nuovi comuni
            } catch {
                print("Errore nel caricamento delle città: \(error)")
                cities = []
            }
            isLoading = false
        }
    }
    
    // Funzione per gestire il clic su un elemento
    func handleItemClick(_ item: String) {
        // Chiama il closure con la città selezionata
        onCitySelected(item)
        showSearchPage = false // Chiudi la pagina di ricerca
    }
}

// Anteprima della SearchView per facilitare il debugging
struct SearchView_Previews: PreviewProvider {
    @State static var showSearchPage = true
    
    static var previews: some View {
        SearchView(showSearchPage: $showSearchPage, onCitySelected: { _ in })
    }
}

