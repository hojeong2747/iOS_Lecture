//
//  ViewController.swift
//  PageControlViewTest
//
//  Created by Dongduk1 on 2023/06/28.
//

import UIKit

class ViewController: UIViewController {
    var images = ["01.png", "02.png", "03.png"," 4.png", "5.png", "06.png"]
    
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
        
        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }

    @IBAction func pageChange(_ sender: UIPageControl) {
        cur = pageControl.currentPage
        imgView.image = UIImage(named: images[cur])
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left: // 내가 생각한 거랑 반대 방향이었음
                if cur != 5 {
                    cur = cur + 1
                    imgView.image = UIImage(named: images[cur])
                    pageControl.currentPage = cur
                }
            case UISwipeGestureRecognizer.Direction.right:
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
    
}

