//
//  SoundwichFeedViewController.swift
//  soundwich
//
//  Created by Tommy Chheng on 9/25/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class SoundwichFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SoundwichFeedCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var soundwiches:[Soundwich] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Soundwich"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "onAdd:")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension

        // Add refresh control to the tableView
        refreshControl = buildRefreshControl()
        tableView.insertSubview(refreshControl, atIndex:0)
        
        tableView.registerNib(UINib(nibName: "SoundwichFeedCell", bundle: nil), forCellReuseIdentifier: "SoundwichFeedCell")

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI
    func buildRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh...", attributes: [NSForegroundColorAttributeName: UIColor.orangeColor()])
        refreshControl.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)

        return refreshControl
    }
    
    func onAdd(sender: AnyObject) {
        let soundwich = Soundwich(title: "New")
        SoundwichStore.add(soundwich)

        pushEditor(soundwich)
    }
    
    func onEditTapped(soundwich:Soundwich, sender: AnyObject) {
        pushEditor(soundwich)
    }
    
    // MARK: - Data
    func loadData() {
        let soundwiches = SoundwichStore.getAll()
        self.soundwiches = soundwiches
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - Table Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundwiches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SoundwichFeedCell", forIndexPath: indexPath) as! SoundwichFeedCell
        
        cell.delegate = self
        cell.soundwich = self.soundwiches[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - Navigation
    func pushEditor(soundwich:Soundwich) {
        let identifier = "SoundwichEditorViewController"
        let vc = navigationController?.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! SoundwichEditorViewController
        vc.soundwich = soundwich
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
