//
//  WeatherView.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 25/09/24.
//

import SwiftUI


struct WeatherView : View {
    var weather: ResponseBody
    
    @State private var showSearchPage: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading){
            VStack{
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(weather.name).bold().font(.title)
                            Text("Oggi, \(Date().formatted(.dateTime.month().day().hour().minute().locale(Locale(identifier: "it_IT"))))")
                                .fontWeight(.light)
                        }
                        
                        Spacer() // Spinge l'icona verso destra

                        // Icona lente di ingrandimento
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 35))
                            .bold()
                            .foregroundColor(.white)
                            .onTapGesture {
                                withAnimation {
                                    showSearchPage = true
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack{
                    
                    HStack {
                        VStack(spacing: 20) {
                            // Usa la funzione per selezionare l'icona in base alla descrizione del meteo
                            Image(systemName: getWeatherIcon(for: weather.weather[0].main))
                                .font(.system(size: 40))
                            
                            // Mostra la descrizione del meteo
                            Text(weather.weather[0].main)
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        // Mostra la temperatura percepita arrotondata
                        Text(weather.main.feelsLike.roundDable() + "°")
                            .font(.system(size: 90))
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Spacer().frame(height: 80)
                    
                    AsyncImage(url : URL(string: "https://cdn.pixabay.com/photo/2022/07/04/12/48/buildings-7301094_1280.png")) {
                        phase in
                        if let image = phase.image {
                            image
                                .resizable() // Assicurati di chiamare resizable sull'immagine esistente
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                        } else if phase.error != nil {
                            // Visualizza un'immagine o un testo di fallback in caso di errore
                            Text("Errore nel caricamento dell'immagine")
                        } else {
                            // Placeholder durante il caricamento
                            ProgressView()
                        }
                        Spacer()
                    }
                    
                }.frame(maxWidth: . infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Condizioni Climatiche")
                        .bold()
                        .padding(.bottom)
                    
                    HStack {
                        WeatherRow(logo: "thermometer", name: "Min Temp.", value: (weather.main.tempMin.roundDable() + ("°")))
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max Temp.", value: (weather.main.tempMax
                            .roundDable() + "°"))
                    }
                    
                    HStack {
                        WeatherRow(logo: "wind", name: "Vento", value: (weather.wind.speed.roundDable2() + " m/s"))
                        Spacer()
                        WeatherRow(logo: "humidity.fill", name: "Umidità", value: "\(weather.main.humidity.roundDable2())%")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.658, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
        // Modale che mostra la pagina di ricerca quando showSearchPage è true
                .fullScreenCover(isPresented: $showSearchPage) {
                    SearchView(showSearchPage: $showSearchPage)
                }
    }
    
}



struct WeatherView_Previews: PreviewProvider{
    static var previews: some View{
        WeatherView(weather: previewWeather)
    }
}
