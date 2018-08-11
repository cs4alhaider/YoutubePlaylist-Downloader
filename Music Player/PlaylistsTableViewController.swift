//
//  PlaylistsTableViewController.swift
//  Music Player
//
//  Created by 岡本拓也 on 2016/01/02.
//  Copyright © 2016年 Sem. All rights reserved.
//

import UIKit
import CoreData

class PlaylistsTableViewController: UITableViewController {
    
    @IBAction func didTapAddButton(_ sender: AnyObject) {
        showTextFieldDialog("Add playlist", message: "", placeHolder: "Name", okButtonTitle: "Add", didTapOkButton: { title in
            self.addPlaylist(title!)
            self.refreshPlaylists()
        })
    }
    
    fileprivate var context : NSManagedObjectContext!
    
    var playlists: NSArray!
    var playlistNames : [String] = []
    var playlistSortDescriptor  = NSSortDescriptor(key: "playlistName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel = UIApplication.shared.delegate as? AppDelegate
        context = appDel!.managedObjectContext
        
        setCellHeight()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false 
        //set background image
        tableView.backgroundColor = UIColor.white
//        let imgView = UIImageView(image: UIImage(named: "pastel.jpg"))
//        imgView.frame = tableView.frame
//        tableView.backgroundView = imgView
        
        refreshPlaylists()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setBackButtonTitle("")
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    fileprivate func setCellHeight() {
        
        var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        let height = screenHeight * 0.72
        tableView.rowHeight = height / 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! PlaylistsTableViewCustomCell
        //cell.textLabel?.text = playlistNames[indexPath.row]
        cell.playlistTitle?.text = playlistNames[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistName = playlistNames[indexPath.row]
        performSegue(withIdentifier: "PlaylistsToPlaylist", sender: playlistName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "PlaylistsToPlaylist") {
            let playlistName = sender as! String
            let playlistVC = (segue.destination as? PlaylistViewController)!
            playlistVC.playlistName = playlistName
        }
    }
    
    
    func addPlaylist(_ name: String){
        if(!SongManager.isPlaylist(name)){
            let newPlaylist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: self.context)
            newPlaylist.setValue(name, forKey: "playlistName")
            
            do{
                try self.context.save()
            }catch _ as NSError{}
        }
        
    }
    
    func refreshPlaylists(){
        playlistNames = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
        request.sortDescriptors = [playlistSortDescriptor]
        
        playlists = try! context.fetch(request) as NSArray?
        for playlist in playlists{
            let playlistName = (playlist as AnyObject).value(forKey: "playlistName") as! String
            playlistNames += [playlistName]
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    //swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(at: indexPath)
        }
    }
    
    fileprivate func delete(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Warning",
                                      message: "Are you sure you want to delete this playlist and all the songs in it ?",
                                      preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            let row = indexPath.row
            let playlistName = (self.playlists[row] as AnyObject).value(forKey: "playlistName") as! String
            self.deletePlaylist(playlistName)
            self.refreshPlaylists()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    //delete playlist and all songs in it
    func deletePlaylist(_ playlistName : String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
        request.predicate = NSPredicate(format: "playlistName = %@", playlistName)
        let fetchedPlaylists : NSArray = try! context.fetch(request) as NSArray
        let selectedPlaylist = fetchedPlaylists[0] as! NSManagedObject
        
        let songs = selectedPlaylist.value(forKey: "songs") as! NSSet
        
        var songIdentifiers : [String] = []
        for song in songs{
            let identifier = (song as AnyObject).value(forKey: "identifier") as! String
            songIdentifiers += [identifier]
        }
        
        for identifier in songIdentifiers{
            SongManager.deleteSong(identifier, playlistName: playlistName)
        }
        context.delete(selectedPlaylist)
        
        do {
            try context.save()
        } catch _ {
        }
    }
    
}
