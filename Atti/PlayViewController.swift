//
//  PlayViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit
import youtube_ios_player_helper

struct Response: Codable {
    let success: Bool
    let result: String
    let message: String
}

class PlayViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet var playerview: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        request("https://www.googleapis.com/youtube/v3/search?part=snippet&q=Lovelyz&order=date&key=AIzaSyAjDYIThr8CM_RBWSJoapBaFhiIhnlVovo", "GET") { (success, data) in
          print(data)
        }
        
        playerview.delegate = self
        playerview.load(withVideoId: "vDxD4HwEFdY", playerVars: ["playsinline": 1])
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
    
    func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
        if method == "GET" {
            requestGet(url: url) { (success, data) in
                completionHandler(success, data)
            }
        }
    }
}
