//
//  LoginViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/26.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

enum LoginPage {
    case phone
    case code
    case guide
    case kind
    var title : String {
        switch self {
        case .phone:
            return "手机号"
        case .code:
            return "验证码"
        case .guide:
            return "引导扫描二维码"
        case .kind:
            return "选择种类"
        }
        
    }
}


class LoginViewController: ZBaseViewController {
    
    var pageId : LoginPage! = .phone //
    var phoneNumber : String!
    var code : String! = ""
    
    let disposeBag = DisposeBag()
    var petInfo : PetModel = PetModel()
    
    
    var bgView = UIView().bgColor(UIColor.white)
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        print("\(pageId.title):petInfo:\(petInfo)")
        
        setupUI()
        
//        var data1 = Data([0x01 , 0x02])
//        print("data1==\(PHData.controlLight(0))")
        
        let values : [UInt8] = [
            0xaa ,
            0x10 ,
            0x01,
            0x00,
            0x00
        ]
        print("ccc===\(values.suffix(from: 1))")
         
         let _ = OTAManager.shared
    
   }
    
    
    func dataToInt(_ data: Data) -> Int? {
        guard data.count == MemoryLayout<Int>.size else { return nil }
        return data.withUnsafeBytes { $0.load(as: Int.self) }
    }
    
    func login() {
        
        let vc = LoginViewController()
        vc.pageId = .guide
        navigationController?.pushViewController(vc, animated: true)
        
        return
        
        guard let phone = phoneNumber else {return}
       
//        NetWork.request(target: .loginByVerifyCode(parameters: ["phone" : phone , "code": code])) { response in
////            guard let res = response ,
////                  let code = res.code,
////                  let error = res.error else {return}
////            
////            if(code != 200) {
////                print("error==\(error)")
////                return
////            }
//            
//    
//            //处理业务
//            //存储token
//            guard let data = response!.data as? [String :Any ] else {return}
//            let profile = data["profile"] as! [String :Any ]
//            _ = ModelTool.dictionaryToModel(profile , UserModel.self)
//            UserDefaults.standard.setValue(data["token"], forKey: "token")
//            UserDefaults.standard.setValue(true, forKey: "isLogin")
//            
//        } error: { error in } failure: { moyaError in}
        
    }
    
   
    
    
    private func sendVerifyCode() {
        
        let vc = LoginViewController()
        vc.pageId = .code
        vc.phoneNumber = phoneNumber
        
        navigationController?.pushViewController(vc, animated: true)
        
        
//        NetWork.request(target: .sendVerifyCode(parameters: ["phone" : phoneNumber])) { response in
////            guard let res = response ,
////                  let code = res.code,
////                  let error = res.error else {return}
////            if(code != 200) {
////                print("error==\(error)")
////                return
////            }
//            //处理业务
//            
//        } error: { error in} failure: { moyaError in}
        
    }
    
    func scan() {
        let vc = QRScanViewController()
       
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func creatPetInfo(_ type : String?) {
     
        petInfo.species = type
        let vc = PetInfoViewController()
        vc.petInfo = petInfo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectSpecies() {
        let vc = LoginViewController()
        vc.pageId = .kind
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


// UI
extension LoginViewController {
    
    private func setupUI() {
        
        let topImgv = UIImageView(image: UIImage(named: "")).bgColor(UIColor.blue)
        topImgv.add2(view).lyt { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(DHPXSW(s: (180 + PHStatusBarHeight())))
        }
        
        
        bgView.add2(view).lyt { make in
            make.top.equalTo(topImgv.snp.bottom).offset(DHPXSW(s: -10))
            make.left.right.bottom.equalTo(0)
        }
        // 设置 yourView 的左上角和右上角为圆角
        let cornerRadius: CGFloat = 24.0
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        bgView.layer.cornerRadius = cornerRadius
        bgView.layer.maskedCorners = maskedCorners
        bgView.layer.masksToBounds = true // 确保超出边界的部分被裁剪
        
        
        switch pageId {
        case .phone:
            phoneUI()
        case .code:
            codeUI()
        case .guide:
            guideUI()
        case .kind:
            kindUI()
            
        default:
            break
            
        }
        
       

    }
    
    private func phoneUI() {
        let contentVue = PhoneView(frame: bgView.bounds)
        contentVue.add2(bgView).lyt { make in
            make.left.right.top.bottom.equalTo(0)
        }
      
        contentVue.nextClick = { [weak self] phone in
            self?.phoneNumber = phone
            self?.sendVerifyCode()
        }
        contentVue.protocolClick = { [weak self] proto in
            print("查看协议==\(proto ?? "")")
            
            
        }
        
        
    }
    
    
    
    
    private func codeUI() {
        let inputCodeVue = InputCodeVue(frame: bgView.bounds, phone: phoneNumber)
        inputCodeVue.add2(bgView).lyt { make in
            make.left.right.top.bottom.equalTo(0)
        }
        inputCodeVue.buttonClick = { [weak self] in
            self?.login()
        }
        inputCodeVue.backClick = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

    }
    
    private func guideUI() {
        
        let guideVue = GuideVue(frame:bgView.bounds)
        guideVue.add2(bgView).lyt { make in
            make.left.right.top.bottom.equalTo(0)
        }
        guideVue.bindClick = { [weak self] in
            
            self?.scan()
        }
        
        guideVue.cancelClick = {  [weak self] in
            self?.selectSpecies()
        }
        
        
    }
    
    private func kindUI() {
        let kindVue = PetKindVue(frame: bgView.bounds)
        kindVue.add2(bgView).lyt { make in
            make.left.right.top.bottom.equalTo(0)
        }
        kindVue.nextClick = { [weak self] index in
            print("选中==\(index)")
            self?.creatPetInfo("\(index)")
        }
        
        kindVue.cancelClick = {  [weak self] in
            self?.creatPetInfo(nil)
        }
    }
    
    
    
    override func viewControllerIsNeedNavBar(_ viewController: ZBaseViewController) -> Bool {
        return false
    }
    
    
}
