import SwiftUI

struct WeatherView : View {
    @State var weather: ResponseBody
    @State private var showSearchPage: Bool = false
    var weatherManager = WeatherManager()
    
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
                            Image(systemName: getWeatherIcon(for: weather.weather[0].main))
                                .font(.system(size: 40))
                            
                            Text(weather.weather[0].main)
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
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
                    
                }.frame(maxWidth: .infinity)
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
                        WeatherRow(logo: "thermometer", name: "Min Temp.", value: (weather.main.tempMin.roundDable() + "°"))
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max Temp.", value: (weather.main.tempMax.roundDable() + "°"))
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
        .fullScreenCover(isPresented: $showSearchPage) {
            SearchView(showSearchPage: $showSearchPage, onCitySelected: { city in
                Task {
                    await fetchWeather(for: city.nome)
                }
            })
        }
    }
    
    // Funzione asincrona per ottenere i dati meteo per la città selezionata
    func fetchWeather(for city: String) async {
        do {
            let newWeather = try await weatherManager.getCurrentWeather(city: city)
            DispatchQueue.main.async {
                weather = newWeather
            }
        } catch {
            print("Errore nel recupero dei dati: \(error)")
        }
    }
    
}

struct WeatherView_Previews: PreviewProvider{
    static var previews: some View{
        WeatherView(weather: previewWeather)
    }
}
