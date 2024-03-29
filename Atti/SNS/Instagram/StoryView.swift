import SwiftUI

struct StoryView: View {
    let stories: [Story]
    var body: some View {
        HStack {
            ForEach(stories, id: \.id) { (story) in
                ZStack {
                    Circle()
                        .fill(Color.init(red: 192/255, green: 53/255, blue: 132/255))
                        .clipShape(Circle())
                        .frame(width: 64, height: 64)
                    Circle()
                        .fill(Color.white)
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 56, height: 56)
                }
            }
        }
    }
}

