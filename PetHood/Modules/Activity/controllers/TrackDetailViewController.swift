//
//  TrackDetailViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/16.
//

import UIKit
import Photos

class TrackDetailViewController: ZBaseViewController {
    
    private var detailView = TrackDetailView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailView.add2(view).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        detailView.shareClosure = { [weak self] in
            self?.shareAction()
        }
        
       
    }
    
    private func shareAction() {
        
        let shareVue = ShareBottomVue(frame: .zero)
        guard let window = UIApplication.shared.windows.first else {return}
        shareVue.add2(window).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let shareImageView = TrackDetailView(CGRect(x: 0, y: 0, width: DHPXSW(s: 375), height: DHPXSW(s: 600)), true).bgColor(.white)
        view.addSubview(shareImageView)
        let image = shareImageView.toImage()?.byRoundCornerRadius(DHPXSW(s: 12))
        shareImageView.removeFromSuperview()
        let imgv = UIImageView(image: image)
        
        shareVue.addSubview(imgv)
        imgv.lyt { make in
            make.centerX.equalTo(shareVue.snp.centerX)
            make.top.equalTo(DHPXSW(s: 46))
            make.width.equalTo(DHPXSW(s: 287))
            make.height.equalTo(PHDHPXscaleH(530))
        }
        
        shareVue.shareClickClouse = { [weak self, shareVue , image]  index in
            print("share===\(index)")
            shareVue.dismiss()
            self?.shareAction(index , image)
            
        }
    }
    
    
    override func zNavigationBarBackgroundImage(_ navigationBar: ZBaseNavigationBar) -> UIImage {
        return UIImage.creatImage(color: .clear)
    }

}


extension TrackDetailViewController {
    
    private func shareAction(_ index:Int , _ image:UIImage?) {
        if index == 0 {
            print("保存到本地")
            let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            if(authorizationStatus == .notDetermined) {
                PHPhotoLibrary.requestAuthorization { [weak self , image] status in
                    if status == .authorized {
                        
                        self?.saveImageToLocale(image)
                    }
                }
            } else if authorizationStatus == .authorized {
                saveImageToLocale(image)
            } else {
                view.toast("请在iPhone的“设置--隐私--相册”选项中，允许此App访问你的相册。")
            }
            
        } else if index == 1 {
            print("分享到微信")
        }
    }
    
    
    private func saveImageToLocale(_ img:UIImage?) {
        print("save photo")
        guard let image = img else {return}
        PHPhotoLibrary.shared().performChanges ({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { [weak self] success, error in
            if success {
            
                self?.view.toast("保存成功");
    
            }else {
                
                self?.view.toast("保存失败，原因==\(String(describing: error?.localizedDescription))")
            }
            
        })
    }
}

