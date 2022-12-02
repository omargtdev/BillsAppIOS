//
//  LaunchViewController.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/27/22.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {

    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animationView = .init(name: "bill_animation")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.performSegue(withIdentifier: "goMain", sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animationView?.stop()
        animationView = nil
    }

}
