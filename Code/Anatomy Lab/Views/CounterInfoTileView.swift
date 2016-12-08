//
//  CounterInfoTileView.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 11/26/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

protocol ProgressTileInformationViewModelType {
    
    var title: String {get}
    var count: Int {get}
    
}

class CounterInfoTileView: UIView {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        setupViews()
    }
    
    func configure(withViewModel viewModel: ProgressTileInformationViewModelType?) {
        
        guard let validViewModel = viewModel else { return }
        
        setupViews()
        
        titleLabel.text = validViewModel.title
        counterLabel.text = String(validViewModel.count)
    }
    
}

// MARK: - Private UI API

private extension CounterInfoTileView {
    
    func setupViews() {
        
        view.layer.borderColor = UIColor.blackColor().CGColor
        view.layer.borderWidth = 1.0
        
        titleLabel.font = UIFont.boldSystemFontOfSize(20)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.textAlignment = .Left
        
        counterLabel.font = UIFont.boldSystemFontOfSize(30)
        counterLabel.textAlignment = .Right
        
    }
    
    func setup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CounterInfoTileView", bundle: bundle)
        
        view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        
        setNeedsLayout()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}