import SwiftUI
import UserNotifications

struct MotivationView: View {
    @State private var currentQuote = MotivationView.randomQuote()
    @State private var customMessage: String = ""
    @State private var savedMessages: [String] = []
    @State private var favoriteQuotes: [String] = []  // Favorietenlijst
    @State private var showTimePicker = false
    @State private var notificationTime = Date()
    @State private var isNotificationSet = false

    var body: some View {
        ScrollView { // Maak de gehele view scrollbaar
            VStack(spacing: 20) {
                // Titel
                Text("Motivational Quotes")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                // Random Quote
                VStack {
                    Text("Quote of the Day")
                        .font(.headline)
                    Text(currentQuote)
                        .font(.title2)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Voeg een ster-icoon toe om de quote als favoriet te markeren
                    HStack {
                        Button(action: {
                            toggleFavorite(currentQuote)
                        }) {
                            Image(systemName: favoriteQuotes.contains(currentQuote) ? "star.fill" : "star")
                                .foregroundColor(favoriteQuotes.contains(currentQuote) ? .yellow : .gray)
                                .font(.title)
                        }
                        .padding()
                    }
                }
                
                Button(action: {
                    currentQuote = MotivationView.randomQuote()
                }) {
                    Text("Get New Quote")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Divider()
                
                // Custom Messages
                VStack(alignment: .leading) {
                    Text("Your Motivational Messages")
                        .font(.headline)
                    
                    TextField("Add your motivational message", text: $customMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        if !customMessage.isEmpty {
                            savedMessages.append(customMessage)
                            saveMessages()
                            customMessage = ""
                        }
                    }) {
                        Text("Save Message")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // Saved Messages List
                    ForEach(savedMessages, id: \.self) { message in
                        HStack {
                            Text(message)
                                .padding()
                                .background(Color(uiColor: .systemGray6))
                                .cornerRadius(10)
                            Spacer()
                            Button(action: {
                                deleteMessage(message)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                
                Divider()
                
                // Dagelijkse Motivatie Herinnering
                VStack {
                    Text("Daily Motivation Reminder")
                        .font(.headline)
                    
                    Button(action: {
                        showTimePicker.toggle()
                    }) {
                        Text(isNotificationSet ? "Wijzig herinneringstijd" : "Stel dagelijkse herinnering in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    if showTimePicker {
                        DatePicker(
                            "Kies een tijd:",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .onChange(of: notificationTime) { _ in
                            scheduleNotification()
                        }
                    }
                }
                
                Divider()
                
                // Favoriete Quotes sectie
                VStack {
                    Text("Favorite Quotes")
                        .font(.headline)
                        .padding(.top)
                    
                    // Lijst van favoriete quotes
                    ForEach(favoriteQuotes, id: \.self) { favorite in
                        Text(favorite)
                            .font(.body)
                            .padding()
                            .background(Color(uiColor: .systemGray5))
                            .cornerRadius(10)
                    }
                }
                .padding(.top)
            }
            .padding()
            .onAppear {
                loadMessages()
                loadFavorites()
            }
        } // ScrollView om scrollen toe te voegen
    }
    
    // Functie voor random quote
    static func randomQuote() -> String {
        let quotes = [
            "Believe you can and you're halfway there.",
            "The only way to do great work is to love what you do.",
            "Don't watch the clock; do what it does. Keep going.",
            "Success is not the key to happiness. Happiness is the key to success.",
            "Act as if what you do makes a difference. It does.",
            "With the new day comes new strength and new thoughts.",
            "Dream big and dare to fail.",
            "Hardships often prepare ordinary people for an extraordinary destiny.",
            "The only limit to our realization of tomorrow will be our doubts of today.",
            "You are never too old to set another goal or to dream a new dream.",
            "What you get by achieving your goals is not as important as what you become by achieving your goals.",
            "Keep your face always toward the sunshine—and shadows will fall behind you.",
            "It always seems impossible until it’s done.",
            "Don’t stop when you’re tired. Stop when you’re done.",
            "Don’t count the days, make the days count.",
            "You don’t have to be great to start, but you have to start to be great.",
            "Success is walking from failure to failure with no loss of enthusiasm.",
            "The future belongs to those who believe in the beauty of their dreams.",
            "Your only limit is your mind.",
            "Push yourself, because no one else is going to do it for you.",
            "Great things never come from comfort zones.",
            "Dream it. Wish it. Do it.",
            "Success doesn’t just find you. You have to go out and get it.",
            "Don’t wait for opportunity. Create it.",
            "Sometimes we’re tested not to show our weaknesses, but to discover our strengths.",
            "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.",
            "Challenges are what make life interesting. Overcoming them is what makes life meaningful.",
            "A little progress each day adds up to big results.",
            "Motivation is what gets you started. Habit is what keeps you going.",
            "Fall seven times and stand up eight."
        ]
        return quotes.randomElement() ?? "Stay motivated!"
    }
    
    // Notificatieplanning
    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Dagelijkse Motivatie"
                content.body = MotivationView.randomQuote()
                content.sound = .default

                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: notificationTime)
                let minute = calendar.component(.minute, from: notificationTime)
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "dailyMotivation", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            isNotificationSet = true
                            showTimePicker = false
                        }
                    }
                }
            }
        }
    }

    // Opslag functies
    func saveMessages() {
        UserDefaults.standard.set(savedMessages, forKey: "savedMessages")
    }
    
    func loadMessages() {
        if let loadedMessages = UserDefaults.standard.array(forKey: "savedMessages") as? [String] {
            savedMessages = loadedMessages
        }
    }
    
    func deleteMessage(_ message: String) {
        if let index = savedMessages.firstIndex(of: message) {
            savedMessages.remove(at: index)
            saveMessages()
        }
    }
    
    // Functie voor favorieten
    func toggleFavorite(_ quote: String) {
        if favoriteQuotes.contains(quote) {
            favoriteQuotes.removeAll { $0 == quote }
        } else {
            favoriteQuotes.append(quote)
        }
        saveFavorites()
    }
    
    func loadFavorites() {
        if let loadedFavorites = UserDefaults.standard.array(forKey: "favoriteQuotes") as? [String] {
            favoriteQuotes = loadedFavorites
        }
    }
    
    func saveFavorites() {
        UserDefaults.standard.set(favoriteQuotes, forKey: "favoriteQuotes")
    }
}

struct MotivationView_Previews: PreviewProvider {
    static var previews: some View {
        MotivationView()
    }
}
