//
//  QRScanViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/9/3.
//

import UIKit
import AVFoundation


var flag = true

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession :AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    fileprivate var scanVue = UIView()
    fileprivate var timer : Timer?
    fileprivate var annimation_line = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        
        startScanning()
        
        setupUI()
        
        
    }
    
    private func setupUI() {
        
        let titleL = UILabel().txtFont(UIFont.systemFont(ofSize: 18)).txtColor(.white).txt("扫一扫")
        titleL.add2(view).lyt { make in
            make.top.equalTo(PHStatusBarHeight())
            make.height.equalTo(44)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        
        scanVue = UIView().bgColor(.clear)
        scanVue.add2(view).lyt { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.size.equalTo(CGSizeMake(DHPXSW(s: 280), DHPXSW(s: 280)))
        }.cornerRadius(16)
            .borderColor(UIColor.white)
            .borderWidth(2)
        
        annimation_line = CAGradientLayer()
        annimation_line.frame =  CGRect(x: 0, y: 0, width: DHPXSW(s: 300), height: 20)
        annimation_line.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor ,
            UIColor.white.withAlphaComponent(0.5).cgColor]
        scanVue.layer.addSublayer(annimation_line)
        
        timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
        let bottomL = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 16 , weight: .light))
            .txtColor(.white).txt("对准二维码自动识别")
        
        bottomL.add2(view).lyt { make in
            make.top.equalTo(scanVue.snp.bottom).offset(DHPXSW(s: 60))
            make.centerX.equalTo(view.snp.centerX)
        }
        
        //
        let back = UIButton(type: .custom)
            .img(UIImage(named: "back_left_white"))
        
        back.add2(view).lyt { make in
            make.left.equalTo(DHPXSW(s: 16))
            make.centerY.equalTo(titleL.snp.centerY)
            make.width.equalTo(DHPXSW(s: 44))
            make.height.equalTo(DHPXSW(s: 30))
        }
        back.contentHorizontalAlignment = .left
        
        back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 3.0, execute: { [weak self] in
            self?.scanSuccess(result: "我是扫描的ID")
        })
    }
    
    @objc func timerAction() {
        var frame = annimation_line.frame
        
        if frame.origin.y >= DHPXSW(s: 280) - 20 {
            frame.origin.y = 0
            UIView.animate(withDuration: 0.05) { [weak self] in
                self?.annimation_line.frame = frame
            }
            
        } else {
            UIView.animate(withDuration: 0.05) { [weak self] in
                frame.origin.y += 5
                self?.annimation_line.frame = frame
            }
        }

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    private func startScanning() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession ,
              let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        do {
            let capturnDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.addInput(capturnDeviceInput)
            
            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            
            metadataOutput.rectOfInterest = CGRectMake(0.15, 0.24, 0.7, 0.52)
            
        } catch {
            print(error)
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        videoPreviewLayer?.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.4).cgColor
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            if let stringValue = readableObject.stringValue {
                print("扫描结果==\(stringValue)")
                captureSession?.stopRunning()
                scanSuccess(result: stringValue)
                
            }
        }
    }
    
    func scanSuccess(result:String) {
        let vc = LoginViewController()
        vc.petInfo.device_id = result
        vc.pageId = .kind
        navigationController?.pushViewController(vc, animated: true)
        videoPreviewLayer?.removeAllSublayers()
        
    }
    
    
}
