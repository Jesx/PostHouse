//
//  QRScannerViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/7.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import AVFoundation

protocol qrScannerDelegate {
    func getQRString(code: String)
}

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var delegate: qrScannerDelegate!
    
    var stationHint: String!
    
    let fullScreenSize = UIScreen.main.bounds.size
    var closeButton = UIButton(type: .close)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        setQRCodeScan()
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        closeButton.center = CGPoint(
            x: 20,
            y: 30)
        self.view.addSubview(closeButton)
        self.view.bringSubviewToFront(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func setQRCodeScan() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        //顯示 Scan Area Window 框框
        let size = Int(0.7 * view.frame.size.width)
        let xPos = (Int(view.frame.size.width)/2) - (size/2)
        let yPos = (Int(view.frame.size.height)/2) - (size/2)
        let scanRect = CGRect(x: CGFloat(xPos), y: CGFloat(yPos) , width: CGFloat(size) , height: CGFloat(size))
        
        //設定 Scan Area Window 框框
        let scanAreaView = UIView()
        scanAreaView.layer.borderColor = UIColor.gray.cgColor
        scanAreaView.layer.borderWidth = 3
        scanAreaView.frame = scanRect
        
        view.addSubview(scanAreaView)
        view.bringSubviewToFront(scanAreaView)
        
        //顯示 Label
        let rect = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 30)
        let label = UILabel(frame: rect)
        label.numberOfLines = 1
        label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.text = stationHint
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "Helvetica-Light", size: 24)
        label.textAlignment = .center
        view.addSubview(label)
        view.bringSubviewToFront(label)
        
        
        createOverlay(frame: view.frame)
        captureSession.startRunning()
        
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func createOverlay(frame : CGRect)
    {
        let overlayView = UIView(frame: frame)
        overlayView.alpha = 0.6
        overlayView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(overlayView)
        
        let maskLayer = CAShapeLayer()
        
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        
        let size = Int(0.7 * view.frame.size.width)
        let xPos = (Int(view.frame.size.width)/2) - (size/2)
        let yPos = (Int(view.frame.size.height)/2) - (size/2)
        
        path.addRect(CGRect(x: xPos, y: yPos, width: size, height: size))
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        maskLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        maskLayer.path = path;
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
    }
    
    @objc func closeWindow() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            guard let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        delegate.getQRString(code: code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}


