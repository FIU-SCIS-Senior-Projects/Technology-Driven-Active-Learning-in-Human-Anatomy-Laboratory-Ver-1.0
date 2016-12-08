//
//  ProfileView.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/5/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

protocol ProfileViewModelType {
    
    var image: UIImage { get }
    var name: String { get }
    
}

class ProfileView: UIView {

    weak var imageView: UIImageView?
    weak var nameLabel: UILabel?
    
    typealias ImageViewSelectionHandlerType = () -> Void
    var imageViewSelectionHandler: ImageViewSelectionHandlerType?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.layer.cornerRadius = (imageView?.frame.width ?? 120) * 0.5
    }
    
    func configure(withViewModel viewModel: ProfileViewModelType?) {
        
        guard let validViewModel = viewModel else {
            return
        }
        imageView?.image = validViewModel.image
        nameLabel?.text = validViewModel.name
    }

}

// MARK: - Private UI API

private extension ProfileView {
    
    func setupViews() {
        
        backgroundColor = UIColor.fiuBlue()
        
        //
        // Image view
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.greenColor()
        imageView.layer.masksToBounds = true
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        imageView.contentMode = .ScaleAspectFit
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileView.imageViewSelected)))
        
        addSubview(imageView)
        self.imageView = imageView
        
        imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        imageView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 30).active = true
        imageView.widthAnchor.constraintEqualToConstant(120).active = true
        imageView.heightAnchor.constraintEqualToConstant(120).active = true
        
        //
        // Name label
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor.fiuGolden()
        nameLabel.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightMedium)
        
        addSubview(nameLabel)
        self.nameLabel = nameLabel
        
        nameLabel.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 20).active = true
        nameLabel.topAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 10).active = true
        nameLabel.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -20).active = true

    }
    
    
    @objc func imageViewSelected() {
        imageViewSelectionHandler?()
    }
}

extension UIColor {
    
    static func fiuBlue() -> UIColor {
        return UIColor(red: 8/255, green: 30/255, blue: 63/255, alpha: 1.0)
    }
    
    static func fiuGolden() -> UIColor {
        return UIColor(red: 182/255, green: 134/255, blue: 44/255, alpha: 1.0)
    }
    
}
