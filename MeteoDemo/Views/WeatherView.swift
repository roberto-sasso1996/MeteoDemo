//
//  WeatherView.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 25/09/24.
//

import SwiftUI


struct WeatherView : View {
    var weather: ResponseBody
    
    var body: some View {
        ZStack(alignment: .leading){
            VStack{
                VStack(alignment: .leading , spacing: 5){
                    Text(weather.name).bold().font(.title)
                    
                    Text("Oggi, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack{
                    HStack{
                        VStack(spacing:20){
                            Image(systemName: "sun.max")
                                .font(.system(size: 40))
                            
                            Text(weather.weather[0].main)
                        }.frame(width: 150 , alignment: .leading)
                        
                        Spacer()
                        
                        Text(
                            weather.main.feelsLike.roundDable() + "°"
                        ).font(.system(size: 90)).fontWeight(.bold).padding()
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
            
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.658, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider{
    static var previews: some View{
        WeatherView(weather: previewWeather)
    }
}
