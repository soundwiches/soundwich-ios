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
    var soundwichPlayerController:SoundwichPlayerController?
    
    var soundwiches:[Soundwich] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "onAdd:")
        
        soundwichPlayerController = SoundwichPlayerController()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Soundwich"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsetsZero

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
        let randomNum = Int(rand())
        let soundwich = Soundwich(title: "New \(randomNum)")

        SoundwichStore.add(soundwich, callback:{(soundwich, error) in
            NSLog("added")
            
            if let s = soundwich {
                self.pushEditor(s)
            }

        })
    }

    func onPause(soundwich:Soundwich, sender: AnyObject) {
        soundwichPlayerController?.toggleAVPlayer()
    }

    func onPlaying(soundwich:Soundwich, sender: AnyObject) {
        NSLog("Playing \(soundwich.title)")
        for soundbite in (soundwich.soundbites ?? []) {
            
            if let ad = soundbite.audioData {
                soundwichPlayerController?.playNSData(ad)
            }
        }
    }
    
    // MARK: - Data
    func loadData() {
        
        SoundwichStore.getAll({ (soundwiches, error) in
            if let s = soundwiches {
                self.soundwiches = s
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    // MARK: - Table Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let soundwich = self.soundwiches[indexPath.row]
        pushEditor(soundwich)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Table Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundwiches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SoundwichFeedCell", forIndexPath: indexPath) as! SoundwichFeedCell
        
        cell.delegate = self
        cell.soundwich = self.soundwiches[indexPath.row]

        let color = ColorTheme.colorRectPalette[indexPath.row % 7]
        cell.backgroundColor = UIColor(red: color[0]/255, green: color[1]/255, blue: color[2]/255, alpha: 0.8)
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
