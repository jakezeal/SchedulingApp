//
//  CalendarCollectionViewController.swift
//  SchedulingApp
//
//  Created by Zeal on 4/21/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class CalendarCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
    }
    
    //MARK:- Preperations
    func prepareCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //MARK:- UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalendarCollectionViewCell
        
        cell.groupLabel.text = "Hello world"
        
        return cell
    }


}
