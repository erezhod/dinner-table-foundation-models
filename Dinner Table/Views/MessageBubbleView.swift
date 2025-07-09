import SwiftUI

struct MessageBubbleView: View {
    let avatarImage: String
    let direction: Direction
    let text: String
    
    enum Direction {
        case received
        case sent
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if direction == .received {
                Image(avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            if direction == .sent { Spacer(minLength: 0) }
            
            ZStack(alignment: direction == .sent ? .trailing : .leading) {
                Text(text)
                    .foregroundColor(direction == .sent ? .white : .primary)
                    .padding(12)
            }
            .background(direction == .sent ? Color.blue : Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 18.0))
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: 260, alignment: direction == .sent ? .trailing : .leading)
            .padding(direction == .sent ? .leading : .trailing, 32)
            
            if direction == .received { Spacer(minLength: 0) }
            if direction == .sent {
                Image(avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 24) {
        MessageBubbleView(
            avatarImage: "avatar_dad",
            direction: .received,
            text: "Hey! Did you hear the latest dad joke?\nIt's a real knee-slapper."
        )
        MessageBubbleView(
            avatarImage: "avatar_teenager",
            direction: .sent,
            text: "No, but I bet it's groan-worthy!"
        )
    }
}
