import SwiftUI

enum CardColor: String, CaseIterable {
    case coeur = "h"
    case pique = "s"
    case trefle = "c"
    case carreau = "d"
    
    func sortOrder() -> Int {
        switch self {
        case .coeur: return 1
        case .pique: return 2
        case .trefle: return 3
        case .carreau: return 4
        }
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let value: Int
    let cardColor: CardColor
}

class CardGameModel: ObservableObject {
    @Published var gameCards = [Card]()
    @Published var playerCards = [Card]()
    @Published var selectedCard: Card? // Add this line to hold the selected card
    
    init() {
        for color in CardColor.allCases {
            for value in 1...13 {
                gameCards.append(Card(value: value, cardColor: color))
            }
        }
    }
    
    @discardableResult func distributeCards(count: Int) -> CardGameModel {
        for _ in 1...count {
            guard !gameCards.isEmpty else {
                return self
            }
            let randomIndex = Int.random(in: 0..<gameCards.count)
            let card = gameCards.remove(at: randomIndex)
            playerCards.append(card)
        }
        return self
    }
    
    @discardableResult func sortPlayerCards() -> CardGameModel {
        playerCards.sort { (card1, card2) -> Bool in
            if card1.cardColor.sortOrder() != card2.cardColor.sortOrder() {
                return card1.cardColor.sortOrder() < card2.cardColor.sortOrder()
            }
            
            let card1Value = card1.value == 1 ? 14 : card1.value
            let card2Value = card2.value == 1 ? 14 : card2.value
            return card1Value < card2Value
        }
        return self
    }
}

struct PlayerCardsView: View {
    @ObservedObject var model: CardGameModel
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    var body: some View {
        VStack {
            if let selectedCard = model.selectedCard {
                CardView(card:selectedCard)
            } else {
                CardView(card:Card(value: 1, cardColor: .coeur)).opacity(-0.6)
            }

            // Use GeometryReader to determine screen width and adjust spacing
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                
                // Calculate the number of cards that can fit in the screen width without overlapping
                let numberOfCards = model.playerCards.count
                
                // Calculate the spacing based on the number of cards
                let spacing = (screenWidth - CGFloat(numberOfCards * 100)) / CGFloat(numberOfCards - 1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(model.playerCards) { card in
                            CardView(card: card)
                                .frame(width: 100) // Adjust width to your desired card width
                                .onTapGesture {
                                    if model.selectedCard != card {
                                        model.selectedCard = card
                                    } else {
                                        model.selectedCard = nil
                                    }
                                }
                                .border(model.selectedCard?.id == card.id ? .blue : .clear)

                                // Add offset if this card is the selected card
                                .rotationEffect(.degrees(model.selectedCard?.id == card.id ? 5.0 : 0.0))
                            
                                .offset(y: model.selectedCard?.id == card.id ? -50 : 0) // Adjust -50 to your desired offset

                                .animation(.default, value: model.selectedCard?.id == card.id) // Add an animation for the offset change
                        }
                    }
                    .padding(.top, 60) // avoid hack to disable clipping...
                }
                .padding(.top, -60) // avoid hack
                
            }
        }
    }
}

// Hack to disable scrollview clipping
/*
import UIKit
extension UIScrollView {
    open override var clipsToBounds: Bool {
        get {
            false
        }
        set {
        }
    }
}*/


struct CardView: View {
    var card: Card
    var value: Int { card.value }
    var cardColor: CardColor { card.cardColor }
    
    var body: some View {
        let imageName = "\(cardColor.rawValue)\(String(format: "%02d", value))"
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct PlayerCards_Previews: PreviewProvider {
    static var model = CardGameModel()
        .distributeCards(count: 12)
        .sortPlayerCards()
    
    static var previews: some View {
        VStack {
            PlayerCardsView(model: model)
        }
    }
}
