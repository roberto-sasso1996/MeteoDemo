//
//  SearchView.swift
//  MeteoDemo
//
//  Created by Christian Soriani on 18/10/24.
//

import SwiftUI

struct SearchView: View {
    // Binding per poter chiudere la pagina di ricerca
    @Binding var showSearchPage: Bool
    @State private var searchText: String = "" // Testo della barra di ricerca
    @State private var selectedItem: String? = nil // Variabile per l'elemento selezionato
    
    
    // Lista di elementi da visualizzare
    let allItems = ["Roma", "Milano", "Napoli", "Torino", "Firenze", "Bologna", "Palermo", "Genova", "Venezia"]
    
    // Computed property per filtrare gli elementi
    var filteredItems: [String] {
        if searchText.isEmpty {
            return allItems // Mostra tutti gli elementi se non c'è testo di ricerca
        } else {
            return allItems.filter { $0.localizedCaseInsensitiveContains(searchText) } // Filtra in base al testo
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
                
                // Lista filtrata con gestione clic
                List(filteredItems, id: \.self) { item in
                    Text(item)
                        .onTapGesture {
                            // Gestione del clic su una riga
                            selectedItem = item
                            handleItemClick(item)
                        }
                }
                .listStyle(PlainListStyle()) // Stile della lista
                
                Spacer() // Riempie lo spazio rimanente
            }
            .navigationTitle("Ricerca")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Funzione per gestire il clic su un elemento
    func handleItemClick(_ item: String) {
        
    }

// Anteprima della SearchView per facilitare il debugging
struct SearchView_Previews: PreviewProvider {
    @State static var showSearchPage = true
    
    static var previews: some View {
        SearchView(showSearchPage: $showSearchPage)
    }
}
