//
//  SoundwichFeedViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class SoundwichFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    var soundwiches:[Soundwich] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let soundwiches = [Soundwich(title: "1"), Soundwich(title: "2")]
        self.soundwiches = soundwiches
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension

        // Add refresh control to the tableView
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex:0)

        
        tableView.registerNib(UINib(nibName: "SoundwichFeedCell", bundle: nil), forCellReuseIdentifier: "SoundwichFeedCell")

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundwiches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SoundwichFeedCell", forIndexPath: indexPath) as! SoundwichFeedCell
        
        cell.soundwich = self.soundwiches[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
}
