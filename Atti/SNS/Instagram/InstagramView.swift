import SwiftUI

struct InstagramView: View {
    
    @State var presentAuth = false
    
    @State var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    
    @State var instagramApi = InstagramApi.shared
    
    @State var signedIn = false
    
    @State var instagramUser: InstagramUser? = nil
    
    @State var instagramImage4 = UIImage(imageLiteralResourceName: "instagram_picture2")
    @State var instagramImage1 = UIImage(imageLiteralResourceName: "instagram_picture4")
    @State var instagramImage2 = UIImage(imageLiteralResourceName: "instagram_picture3")
    @State var instagramImage3 = UIImage(imageLiteralResourceName: "instagram_picture1")
    
    let post2 = Post(id: 0, userName: "blackpinkofficial" , profileImageName: "profile", imageName: "instagram_background", text: "Comment girls letter by letter 📩 #blackpink")
    let post3 = Post(id: 1, userName: "blackpinkofficial", profileImageName: "profile", imageName: "instagram_background", text: "Jenny with her fiends in Paris ☕ #blackpink #jenny")
    let post4 = Post(id: 2, userName: "blackpinkofficial", profileImageName: "profile", imageName: "instagram_background", text: "Jisoo Instagram update 💜 #blackpink #jisoo")
    @State var post1 = Post(id: 3, userName: "blackpinkofficial" , profileImageName: "profile", imageName: "instagram_background", text: "Rose instagram updates! 😻 #Rose #BLACKPINK")
    
    let stories: [Story] = [
        Story(id: 0, imageName: "storyImage"),
        Story(id: 1, imageName: "storyImage1"),
        Story(id: 2, imageName: "storyImage2"),
        Story(id: 3, imageName: "storyImage3"),
        Story(id: 4, imageName: "storyImage4"),
        Story(id: 5, imageName: "storyImage5")
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                        ScrollView(.horizontal, showsIndicators: false) {
                            StoryView(stories: self.stories)
                        }.frame(height: 76).clipped()
                    PostView(post: post1,screenWidth: geometry.size.width,uiImgae: instagramImage1)
                    PostView(post: post2,screenWidth: geometry.size.width,uiImgae: instagramImage2)
                    PostView(post: post3,screenWidth: geometry.size.width,uiImgae: instagramImage3)
                    PostView(post: post4,screenWidth: geometry.size.width,uiImgae: instagramImage4)
                    
                }.navigationBarTitle(Text("Instagram"), displayMode: .inline)
                        .navigationBarItems(leading: Button(action: {
                            if self.instagramUser != nil {
                                self.instagramApi.getImage(testUserData: self.testUserData) { (media) in
                                    if media.media_type != MediaType.VIDEO {
                                        let media_url = media.media_url
                                        self.instagramApi.putImage(urlString: media_url, completion: { (fetchedImage) in
                                            if let imageData = fetchedImage {
                                                self.post1.text = "#BLACKPINK #블랙핑크 #KILLTHISLOVE #MV #1_4BILLION #YOUTUBE #YG"
                                                self.instagramImage1 = UIImage(data: imageData)!
                                            } else {
                                                print("Didn't fetched the data")
                                            }

                                        })
                                        print(media_url)
                                    } else {
                                        print("Fetched media is a video")
                                    }
                                }
                            } else {
                                print("Not signed in")
                            }
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }), trailing: Button(action: {
                            if self.testUserData.user_id == 0 {
                                self.presentAuth.toggle()
                            } else {
                                self.instagramApi.getUser(testUserData: self.testUserData) { (user) in
                                    self.instagramUser = user
                                    self.signedIn.toggle()
                                }
                            }
                        }, label: {
                            Image(systemName: "person.circle")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }))
                }
        }
        .sheet(isPresented: self.$presentAuth) {
            WebView(presentAuth: self.$presentAuth, userData: self.$testUserData, instagramApi: self.$instagramApi)
        }
        .actionSheet(isPresented: self.$signedIn) {
            
            let actionSheet = ActionSheet(title: Text("Signed in:"), message: Text("with account: @\(self.instagramUser!.username)"),buttons: [.default(Text("OK"))])
            
            return actionSheet
            
        }
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
