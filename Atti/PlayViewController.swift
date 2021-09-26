//
//  PlayViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit
import youtube_ios_player_helper

class PlayViewController: UIViewController {
    
    @IBOutlet var playerview: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerview.load(withVideoId: "vDxD4HwEFdY")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
