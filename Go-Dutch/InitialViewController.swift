//
//  InitialViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/24/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let splitModel = SplitModel.sharedInstance
    
//    var stackVC: [UIViewController]!
//    var stackPageVC: [UIViewController]!

    var pageViewController: UIPageViewController!
    var itemPages: [Item]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        let addtoTableVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddToTableViewController") as! AddToTableViewController
        
//        let addItemsVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddItemsViewController") as! AddItemsViewController
//        
//        stackVC = [addtoTableVC, addItemsVC]
//        
//        stackPageVC = [UIViewController]()
//        stackVC.enumerate().forEach { index, viewController in
//            let pageViewController = UIViewController()
//            pageViewController.addChildViewController(viewController)
//            pageViewController.view.addSubview(viewController.view)
//            viewController.didMoveToParentViewController(pageViewController)
//            stackPageVC.append(pageViewController)
//        }
        
        pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([addtoTableVC], direction: .Forward, animated: true, completion: nil)
        
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        pageViewController.view.backgroundColor = UIColor.clearColor()
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setItemPages(items: [Item]) {
        itemPages = items
        
//        itemPages.forEach { item in
//            let assignItemsVC = self.storyboard?.instantiateViewControllerWithIdentifier("AssignItemViewController") as! AssignItemViewController
//            
//            assignItemsVC.currentItem = item
////            assignItemsVC.progressViewProgress = Float(index)/Float(itemPages.count)
//            
//            let pageViewController = UIViewController()
//            pageViewController.addChildViewController(assignItemsVC)
//            pageViewController.view.addSubview(assignItemsVC.view)
//            assignItemsVC.didMoveToParentViewController(pageViewController)
//            stackPageVC.append(pageViewController)
//        }
    }
    
    func itemPageAtIndex(index: Int) -> AssignItemViewController {
        let itemVC: AssignItemViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AssignItemViewController") as! AssignItemViewController
        
        itemVC.currentItem = itemPages[index]
        itemVC.pageIndex = index
        itemVC.progressViewProgress = Float(index)/Float(itemPages.count)
        
        return itemVC
    }
    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        if viewController == stackPageVC.first {
//            return nil
//        }
//        return stackPageVC[stackPageVC.indexOf(viewController)! - 1]
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        if viewController == stackPageVC.last {
//            return nil
//        }
//        return stackPageVC[stackPageVC.indexOf(viewController)! + 1]
//    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vcMirror = Mirror(reflecting: viewController)
        
        if vcMirror.subjectType == AddToTableViewController.self {
            return nil
        } else if vcMirror.subjectType == AddItemsViewController.self {
            return self.storyboard?.instantiateViewControllerWithIdentifier("AddToTableViewController") as! AddToTableViewController
        } else if vcMirror.subjectType == AssignItemViewController.self {
            let currentItemVC = viewController as! AssignItemViewController
            var index: Int = currentItemVC.pageIndex
            
            currentItemVC.savePeopleAndPercentages()
            
            if(index == 0) {
                return self.storyboard?.instantiateViewControllerWithIdentifier("AddItemsViewController") as! AddItemsViewController
            }
            
            index -= 1
            
            return itemPageAtIndex(index)
        } else if vcMirror.subjectType == TaxAndTipViewController.self {
            return itemPageAtIndex(self.itemPages.count-1)
        }
        
        return self.storyboard?.instantiateViewControllerWithIdentifier("AddToTableViewController") as! AddToTableViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vcMirror = Mirror(reflecting: viewController)
        
        if vcMirror.subjectType == AddToTableViewController.self {
            if splitModel.returnAllPeople().count == 0 {
                let warningAlert = UIAlertController.init(
                    title: "Error",
                    message: "Need at least one person to continue.",
                    preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) {(action) in }
                warningAlert.addAction(OKAction)
                
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
                
                return nil
            }
            
            return self.storyboard?.instantiateViewControllerWithIdentifier("AddItemsViewController") as! AddItemsViewController
        } else if vcMirror.subjectType == AddItemsViewController.self {
            self.setItemPages(splitModel.getAllItemsAsArray())
            
            if itemPages.count > 0 {
                return itemPageAtIndex(0)
            } else {
                let warningAlert = UIAlertController.init(
                    title: "Error",
                    message: "Need at least one item to continue.",
                    preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) {(action) in }
                
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
                
                return nil
            }
        } else if vcMirror.subjectType == AssignItemViewController.self {
            let currentItemVC = viewController as! AssignItemViewController
            var index: Int = currentItemVC.pageIndex
            
            currentItemVC.savePeopleAndPercentages()
            
            if(index == itemPages.count - 1) {
                return self.storyboard?.instantiateViewControllerWithIdentifier("TaxAndTipViewController") as! TaxAndTipViewController
            }
            
            index += 1
            
            return itemPageAtIndex(index)
        } else if vcMirror.subjectType == TaxAndTipViewController.self {
            return nil
        }
        
        return self.storyboard?.instantiateViewControllerWithIdentifier("AddToTableViewController") as! AddToTableViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
    }
}
