//
//  CityManager.swift
//  MeteoDemo
//
//  Created by Christian Soriani on 19/10/24.
//
import Foundation

class CityManager{
    func getCityList() async throws -> [City] {
        guard let url = URL(string: "https://axqvoqvbfjpaamphztgd.functions.supabase.co/comuni") else { fatalError("Missing Url")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data , response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching data")}
        
        let decodeData = try JSONDecoder().decode([City].self, from: data) // Decodifica direttamente in un array di City
        return decodeData
    }
}

struct City: Identifiable, Codable {
    let codice: String // Codice della città
    let nome: String   // Nome della città

    var id: String { codice } // Utilizza il codice come identificatore
}

// Modello del corpo della risposta dell’API
struct CityResponseBody: Codable {
    let cities: [City]
}
