//
//  PageViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/14/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
 
    lazy var vcArr : [UIViewController] = {
       return [self.VCInstance(name: "FirstVC"),self.VCInstance(name: "SecondVC"),self.VCInstance(name: "ThirdVC")]
    }()
    private func VCInstance(name:String) -> UIViewController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:name)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = vcArr.first{
            
            setViewControllers([firstVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
                
            }else if view is UIPageControl{
                view.backgroundColor = UIColor.clear
            }
        }
    }
    // Sent when a gesture-initiated transition begins.
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcArr.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = vcArr.index(of: firstViewController) else{
                
                return 0
        }
        return firstViewControllerIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcArr.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return vcArr.last
        }
        guard vcArr.count > previousIndex else {
            return nil
        }
        return vcArr[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArr.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < vcArr.count else {
            return vcArr.first
        }
        guard vcArr.count > nextIndex else {
            return nil
        }
        return vcArr[nextIndex]
    }
    

}
