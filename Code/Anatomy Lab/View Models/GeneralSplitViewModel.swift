//
//  GeneralSplitViewModel.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/19/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import FontAwesome_swift
import UIKit

enum Section: Int {
    case Labs = 0
    case Quizzes
    case Terminology
}

final class GeneralSplitViewModel: NSObject {
    
    var appSection: Section
    var title: String
    var image: UIImage
    
    required init(forSection appSection: Section) {
        
        self.appSection = appSection
        
        switch self.appSection {
        case .Labs:
            self.title = NSLocalizedString("Labs", comment: "")
            self.image = UIImage.fontAwesomeIconWithName(FontAwesome.Flask, textColor: UIColor.whiteColor(), size: CGSizeMake(36.0, 36.0))
            break
        case .Quizzes:
            self.title = NSLocalizedString("Quizzes", comment: "")
            self.image = UIImage.fontAwesomeIconWithName(FontAwesome.QuestionCircle, textColor: UIColor.whiteColor(), size: CGSizeMake(36.0, 36.0))
            break
        case .Terminology:
            self.title = NSLocalizedString("Terminology", comment: "")
            self.image = UIImage.fontAwesomeIconWithName(FontAwesome.ListUL, textColor: UIColor.whiteColor(), size: CGSizeMake(36.0, 36.0))
            break
        }
        super.init()
    }

}
