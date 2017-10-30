//
//  ViewController.swift
//  Pikachu Yakala
//
//  Created by Kemal BALABAN on 27.10.2017.
//  Copyright © 2017 Kemal BALABAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let imageView = UIImageView(image: UIImage(named: "pika.jpg")!)
    var timer = Timer()
    var counter = 0
    var point = 0
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var highScore = UserDefaults.standard.integer(forKey: "highscore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 30
        
        remainingLabel.text = "Remaining Time : \(String(counter))"
        imageView.isUserInteractionEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)
        
        
        highScoreLabel.text = "High Score: \(highScore)"
        
        
    }
    
    @objc func pikachuPosition() {
        let _viewWidth = view.frame.size.width
        let _viewHeight = view.frame.size.height
        
        var pikachuxPosition = CGFloat( arc4random_uniform( UInt32( floor( _viewWidth  ) ) ) )
        var pikachuyPosition = CGFloat( arc4random_uniform( UInt32( floor( _viewHeight ) ) ) )
        if pikachuxPosition > _viewWidth - 100 {
            pikachuxPosition = _viewWidth - 100
        }
        if pikachuxPosition < 100 {
            pikachuxPosition = 100
        }
        if pikachuyPosition > _viewHeight - 100 {
            pikachuyPosition = _viewHeight - 100
        }
        if pikachuyPosition < 250 {
            pikachuyPosition = 250
        }
        imageView.frame = CGRect(x: pikachuxPosition, y: pikachuyPosition, width: 75, height: 75)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addScorePoint))
        imageView.addGestureRecognizer(gestureRecognizer)
        view.addSubview(imageView)
    }
    @objc func addScorePoint() {
        point += 1
        scoreLabel.text = "Score: \(point)"
    }
    @objc func timerFunc() {
        remainingLabel.text = "Remaining Time : \(String(counter))"
        counter = counter - 1
        pikachuPosition()
        if counter == 0 {
            timer.invalidate()
            remainingLabel.text = "You are finished"
            imageView.isUserInteractionEnabled = false
            if point > highScore {
                UserDefaults.standard.set(point, forKey: "highscore")
                UserDefaults.standard.synchronize()
                highScoreLabel.text = "High Score: \(point)"
            }
            alertfunc(titleMessage: "Alert", messageContent: "You are full, your score \(String(point)). Do you want to try again?")
        }
    }
    
    @objc func okButtonClick() {
        imageView.isUserInteractionEnabled = false
    }
    
    @objc func replayButtonClick() {
        counter = 30
        remainingLabel.text = "Remaining Time : \(String(counter))"
        imageView.isUserInteractionEnabled = true
        point = 0
        scoreLabel.text = "Score: \(point)"
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timerFunc), userInfo: nil, repeats: true)
    }
    
    func alertfunc(titleMessage: String, messageContent: String) {
        let alert = UIAlertController(title: titleMessage, message: messageContent, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.okButtonClick() })
        let replayButton = UIAlertAction(title: "REPLAY", style: .default, handler: { _ in self.replayButtonClick() })
        alert.addAction(okButton)
        alert.addAction(replayButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
