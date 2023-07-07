//
//  ViewController.swift
//  PageControlViewTest
//
//  Created by Dongduk1 on 2023/06/28.
//

import UIKit

class ViewController: UIViewController {
    var images = ["01.png", "02.png", "03.png", "4.png", "5.png", "06.png"]
    
    var cur = 0
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = cur
        
        pageControl.pageIndicatorTintColor = UIColor.green
        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        imgView.image = UIImage(named: images[0])
        
        // 이미지 경로 확인
        for imageName in images {
            if let imagePath = Bundle.main.path(forResource: imageName, ofType: nil) {
                print("Image path: \(imagePath)")
            } else {
                print("Image not found for: \(imageName)")
            }
        }
        
        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        // pinch
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
        
    }

    @IBAction func pageChange(_ sender: UIPageControl) {
        cur = pageControl.currentPage
        imgView.image = UIImage(named: images[cur])
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left: // 내가 생각한 거랑 반대 방향이었음
                print("left: \(cur)")
                if cur != images.count - 1 {
                    print("not 5 : \(cur)")
                    cur = cur + 1
                    imgView.image = UIImage(named: images[cur])
                    pageControl.currentPage = cur
                }
            case UISwipeGestureRecognizer.Direction.right:
                print("right: \(cur)")
                if cur != 0 {
                    cur = cur - 1
                    imgView.image = UIImage(named: images[cur])
                    pageControl.currentPage = cur
                }
            default:
                break
            }
        }
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) { // UIGestureRecognizer 상속받은 타입
        imgView.transform = imgView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
}

