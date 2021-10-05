import SwiftUI


struct TwitterView: View {
    @State private var isLoading = true
    
    @State private var isActive = false
    
    private var newTweetURL: URL {
        let urlString = "https://twitter.com/ygofficialblink"
        guard
            let url = URL(string: urlString)
        else { fatalError("Erroneous tweet url detected!") }
        return url
    }

    var body: some View {
        NavigationView {
            ZStack {
                TwitterHTMLView { loadingState in
                    switch loadingState {
                    case .idle:
                        isLoading = false
                    case .loading:
                        isLoading = true
                    }
                }
                if isLoading {
                    VStack {
                        Text("Loading Twitter Feed...")
                        ProgressView()
                    }
                }
            }
            .edgesIgnoringSafeArea(.vertical)
            .navigationBarTitle("Twitter").navigationBarItems(leading: NavigationLink("instagram",destination: InstagramView()).navigationBarTitle("",displayMode:.inline).navigationBarHidden(isActive)
                                                                              ,
                trailing: Link(destination: newTweetURL, label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Web")
                }
            }))
        }
    }
}
