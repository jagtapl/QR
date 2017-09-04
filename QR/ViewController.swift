//
//  ViewController.swift
//  OpenURL
//


import UIKit
import ZXingObjC

class ViewController: UIViewController, ZXCaptureDelegate {
    
    var capture: ZXCapture!
    var captureSquare: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green;
        
        self.capture = ZXCapture()
        self.capture.camera = self.capture.back()
        self.capture.focusMode = AVCaptureFocusMode.continuousAutoFocus
        self.capture.rotation = 90.0
        self.capture.layer.frame = self.view.bounds
        self.view.layer.addSublayer(self.capture.layer)
        
        self.captureSquare = UIView(frame: CGRect.zero)
        self.captureSquare.layer.borderWidth = 1;
        self.captureSquare.layer.borderColor = UIColor.blue.cgColor
        self.view.addSubview(self.captureSquare)
        self.captureSquare.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addConstraint(NSLayoutConstraint(item: self.captureSquare, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.captureSquare, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.captureSquare, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320))
        self.view.addConstraint(NSLayoutConstraint(item: self.captureSquare, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.capture.delegate = self
        self.capture.layer.frame = self.view.bounds;
        
        self.captureSquare.layoutIfNeeded()
        let captureSizeTransform = CGAffineTransform(scaleX: 320/self.view.frame.size.width, y: 480/self.view.frame.size.height)
        self.capture.scanRect = (self.captureSquare.frame).applying(captureSizeTransform);
        
        super.viewWillAppear(animated)
        
        // LALIT - Added to explicitly start the image capture. But it stil does not work.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2)*Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { () -> Void in
            self.capture.start()
        }
    }
    
    func barcodeFormatToString(_ format: ZXBarcodeFormat) -> String {
        switch (format) {
        case kBarcodeFormatAztec:
            return "Aztec";
            
        case kBarcodeFormatCodabar:
            return "CODABAR";
            
        case kBarcodeFormatCode39:
            return "Code 39";
            
        case kBarcodeFormatCode93:
            return "Code 93";
            
        case kBarcodeFormatCode128:
            return "Code 128";
            
        case kBarcodeFormatDataMatrix:
            return "Data Matrix";
            
        case kBarcodeFormatEan8:
            return "EAN-8";
            
        case kBarcodeFormatEan13:
            return "EAN-13";
            
        case kBarcodeFormatITF:
            return "ITF";
            
        case kBarcodeFormatPDF417:
            return "PDF417";
            
        case kBarcodeFormatQRCode:
            return "QR Code";
            
        case kBarcodeFormatRSS14:
            return "RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return "RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return "UPCA";
            
        case kBarcodeFormatUPCE:
            return "UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return "UPC/EAN extension";
            
        default:
            return "Unknown";
        }
    }
    
    var previousImage:UIImageView?
    
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        if result == nil {
            return
        }
        
        let formatString = self.barcodeFormatToString(result.barcodeFormat)
        let display = "Scanned!\n\nFormat: \(formatString)\n\nContents:\n\(result.text)"
        print(display)
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        self.capture.stop()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2)*Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { () -> Void in
            self.capture.start()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
