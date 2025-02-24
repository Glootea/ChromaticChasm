import Cocoa
import FlutterMacOS
import IOKit.ps
import SwiftUI
import AppKit

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        
        RegisterGeneratedPlugins(registry: flutterViewController)
        
        let shareChannel = FlutterMethodChannel(
            name: "com.glootea.chromaticChasm/share",
            binaryMessenger: flutterViewController.engine.binaryMessenger)
        shareChannel.setMethodCallHandler { (call, result) in
            if(call.method == "shareLevel") {
                let args = call.arguments as! Dictionary<String, AnyObject>
                let link = args["link"] as! String;
                self.shareText(link)
                result(true)
            }
            
            super.awakeFromNib()
        }
    }
    
    private func shareText(_ text: String) {
                let sharingPicker = NSSharingServicePicker(items: [text])
                if let window = self.contentView?.window {
                    sharingPicker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
                }
        }
}
