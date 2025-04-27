//
//  MineViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/17.
//

import UIKit
import Moya
import RxSwift
import ObjectMapper


class MineViewController: ZBaseViewController {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        getUserProfile()
        
//        editUserProfile()
//          bindDevice()
        
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)  {
//            self.bindPet()
        }
        
//        editPetInfo()
    
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vue = MineView(frame: view.bounds)
        vue.add2(view)
        
       
        
        // Do any additional setup after loading the view.
    }
    
    private func getDevicePetList() {
        
        let para = ["device_id" : "did_2"]
        NetWork.request(target: .devicePetList(parameters: para)) { response in
            
        } error: { code in
            
        } failure: { error in
            
        }
    }
    
   
    private func editPetInfo() {
        let para = [
            "device_id" : "did_2",
            "name" : "皮卡丘222",
            "avatar_url" : "1",//UIImage(named: "tab_navi_icon_selected")?.pngData()?.base64EncodedString(),
            "species" : "",
            "breed" : "",
            "age" : 1,
            "gender" : "2",
            "weight" : 20,
            "birthdate" : (Int)((Date().timeIntervalSince1970) * 1000),
            "pet_id" : "4d20fb58-a398-4e26-8ef0-fd9a429f02cc"
        ] as [String : Any]
        NetWork.request(target: .updatePetInfo(parameters: para)) { response in
            
        } error: { code in
            
        } failure: { error in
            
        }
    }
    
    
    private func bindPet() {
        let para = [
            "device_id" : "did_2",
            "name" : "皮卡丘",
            "avatar_url" :"",
            "species" : "",
            "breed" : "",
            "age" : "1",
            "gender" : "2",
            "weight" : "20",
            "birthdate" : "\(Date().timeIntervalSince1970)"
        ]
        NetWork.request(target: .bindPet(parameters: para)) { response in
            
        } error: { code in
            
        } failure: { error in
            
        }

    }
    
    
    private func bindDevice() {
        let para = ["device_id" : "did_2"]
        NetWork.request(target: .bindDevice(parameters: para)) { response in
            
        } error: { code in
            
        } failure: { error in
            
        }

    }
    
    private func getUserProfile() {
        NetWork.request(target: .userProfile) { response in
            
        } error: { code in
            
        } failure: { error in
            
        }

    }
    
    private func editUserProfile() {
        let para = [
            "user_name" : "哈哈哈哈"
        ]
        NetWork.request(target: .updateUserProfile(parameters: para)) { response in
            
        } error: { code in
            
        } failure: { error in
            
        }

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewControllerIsNeedNavBar(_ viewController: ZBaseViewController) -> Bool {
        return false
    }
    
}


extension MineViewController {
  
}
