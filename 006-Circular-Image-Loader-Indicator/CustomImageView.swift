//
//  CustomImageView.swift
//  Circular-Image-Loader-Animation
//
//  Created by Audrey Li on 3/19/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView, NSURLSessionDelegate {

    
    var progressIndicatorView: CircularLoaderView!
    var data = NSData()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentMode = .ScaleAspectFill 
        
        progressIndicatorView = CircularLoaderView(frame: bounds)
        addSubview(self.progressIndicatorView)
        
        // autoresizingMask ensures that progress indicator view remains the same size as the image view.
        progressIndicatorView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        
        let url = "http://hdw.datawallpaper.com/nature/just-beautiful-desktop-background-493093.jpg"
        downloadImageWithURL(url)
        
    }
    
    func downloadImageWithURL(url: String) {
        let nsURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: nsURL)
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(SessionProperties.identifier)

        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.downloadTaskWithURL(nsURL)
        downloadTask.resume()
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        var downloadProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        self.progressIndicatorView.progress = CGFloat(downloadProgress)
        self.progressIndicatorView.progressLabel.text = "\(Int(downloadProgress * 100))%"
        println("downloadProgress: \(downloadProgress) \(totalBytesExpectedToWrite)")
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {

        var data = NSData(contentsOfURL: location)
        self.image = UIImage(data: data!)
        self.progressIndicatorView.reveal()
        self.progressIndicatorView.progressLabel.text = ""
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        println("didResumeAtOffset: (fileOffset)")
    }

    
    
}
struct SessionProperties {
    static let identifier:String! = "url_session_background_download"
}
