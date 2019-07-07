//
//  PresentationPageViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 19/06/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit

class PresentationPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    lazy var orderedVC : [UIViewController] = {
        return [ self.newVC(identifier: "FirstSlideViewController"),
                 self.newVC(identifier: "SecondSlideViewController"),
                 self.newVC(identifier: "ThirdSlideViewController")
        ]
    }()  //all slides
    
    var pageControl = UIPageControl() //Dots below
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.dataSource = self
        
        if let firstVC = orderedVC.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        } //Insert first slide
        
        self.configurePageControl()
        
    }
    
    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = self.orderedVC.count
        pageControl.currentPage = 0
        pageControl.tintColor  = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(self.pageControl)
    }
    
    private func newVC(identifier: String) -> UIViewController { //Creates new VC with identifier
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = orderedVC.index(of: viewController) else { // take index of current vc
            return nil
        }
        
        let previousIndex = index - 1
        
        if (previousIndex < 0) || (previousIndex >= orderedVC.count) {
            return nil
        }
        
        return orderedVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedVC.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        
        if (nextIndex < 0) || (nextIndex >=  orderedVC.count) {
            return nil
        }
        
        return orderedVC[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) { //triggers when user changes slide
        if let vc = pageViewController.viewControllers?[0] { // take current vc
            self.pageControl.currentPage = self.orderedVC.index(of: vc) ?? 0 // set page control
        }
    }
    
}
