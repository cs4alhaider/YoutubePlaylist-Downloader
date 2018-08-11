//
//  PlaylistsTableViewCustomCell.swift
//  Music Player
//
//  Created by Abdullah Alhaider on 8/11/18.
//  Copyright © 2018 Sem. All rights reserved.
//

import UIKit

class PlaylistsTableViewCustomCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var playlistBackgroundImage: UIImageView!
    @IBOutlet weak var playlistImage: UIImageView!
    
    @IBOutlet weak var visuallEffectView: UIVisualEffectView!
    @IBOutlet weak var playlistTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setUI() {
        playlistBackgroundImage.clipsToBounds = true
        playlistBackgroundImage.layer.cornerRadius = 15
        
        playlistImage.clipsToBounds = true
        playlistImage.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            playlistImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        visuallEffectView.clipsToBounds = true
        visuallEffectView.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            visuallEffectView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        backView.applyViewDesign(masksToBounds: false, color: .black, cornerRadius: 12, opacity: 0.3, offSet: CGSize(width: 0, height: 0), radius: 12)
    }

}
