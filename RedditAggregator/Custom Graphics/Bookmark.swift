//
//  Bookmark.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 11.04.2022.
//

import UIKit

class Bookmark: UIView {
    let shapeLayer = CAShapeLayer()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        self.shapeLayer.path = self.bookmarkFigure().cgPath
        self.shapeLayer.fillColor = BookmarkConstants.fillColor
        self.shapeLayer.strokeColor = BookmarkConstants.strokeColor
        self.shapeLayer.lineWidth = BookmarkConstants.lineWidth
        self.layer.addSublayer(self.shapeLayer)
    }
    
    private func bookmarkFigure() -> UIBezierPath {
        let start = CGPoint(
            x: self.frame.midX - BookmarkConstants.width / 2,
            y: self.frame.midY - BookmarkConstants.height / 2)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: CGPoint(x: start.x + BookmarkConstants.width,
                                 y: start.y))
        path.addLine(to: CGPoint(x: start.x + BookmarkConstants.width,
                                 y: start.y + BookmarkConstants.height))
        path.addLine(to: CGPoint(x: start.x + BookmarkConstants.width / 2,
                                 y: start.y + BookmarkConstants.height - BookmarkConstants.curveDiff))
        path.addLine(to: CGPoint(x: start.x,
                                 y: start.y + BookmarkConstants.height))
        path.addLine(to: start)
        path.close()
        
        return path
    }
    
    struct BookmarkConstants {
        private static let constLength: CGFloat = 50
        
        static var height: CGFloat {
            constLength * 1.8
        }
        
        static var width: CGFloat {
            constLength
        }
        
        static var curveDiff: CGFloat {
            constLength * 0.5
        }
        
        static let lineWidth: CGFloat = 1.5
        static let fillColor = UIColor.yellow.cgColor
        static let strokeColor = UIColor.blue.cgColor
    }
}
