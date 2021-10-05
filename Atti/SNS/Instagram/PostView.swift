import SwiftUI

struct PostView: View {
    var post: Post
    let screenWidth: CGFloat
    var uiImgae : UIImage
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(post.profileImageName)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .clipped()
                    Text(post.userName).font(.headline)
                }.padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 0))
                Image(uiImage: uiImgae)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: screenWidth)
                    .clipped()
                Text(post.text)
                    .lineLimit(nil)
                    .font(.system(size: 15))
                    .padding(.leading, 16).padding(.trailing, 16).padding(.bottom, 16)
            }.listRowInsets(EdgeInsets())
    }
}
