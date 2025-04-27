//
//  PetInfoViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/9/3.
//

import UIKit

class PetInfoViewController: ZBaseViewController  , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var petInfo = PetModel()
    
    fileprivate var vue = PetInfoVue(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("\(self):petInfo:\(petInfo)")
        
        z_navgationBar.title = NSMutableAttributedString(string: "宠物档案", attributes: [.font : UIFont.systemFont(ofSize: 17)])
        
        
        vue.add2(view).lyt { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(z_navgationBar.snp.bottom)
        }
        
        vue.photoClick = {  [weak self] in
            
            self?.photoAction()
        }
        
        vue.cellClick = {  [weak self] index in
            self?.cellSelect(index)
        }
        
        vue.nextClick = { [weak self] in
            self?.nextAction()
        }
        
        vue.updatePetModel(petInfo)
        
    }
    
    private func photoAction() {
        print("点击 添加头像")
        if let window = keyWindow() {
            let pickView = SelectDataAlertView(frame: window.bounds ,dataType:.avatar , value: "")
            
            window.addSubview(pickView)
            pickView.confirmClick = { [weak self] value in
                print("value ==\(value ?? "取消选择")")
                
                guard let selectedVaule = value else {return}
                
                if selectedVaule == "相册" {
                    self?.pickImageFromCameraRoll()
                } else {
                    self?.takePictureWithCamera()
                }
                
            }
        }
        
    }
    
    // 调用相册
    func pickImageFromCameraRoll() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // 调用相机
    func takePictureWithCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 获取选取的图片
        if let image = info[.originalImage] as? UIImage {
            // 处理图片
            vue.updatePhoto(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func nextAction() {
        print("创建宠物档案")
        guard let birthdate = petInfo.birthdate else {return}
        let age = PHTool.calculateAge(from: birthdate.toDate())
        
//        var para = [
//            "device_id" : petInfo.device_id ?? "",
//            "name" : petInfo.name ?? "",
//            "avatar_url" : petInfo.avatar_url ?? "",
//            "species" : petInfo.species ?? "",
//            "breed" : petInfo.breed ?? "",
//            "age" : "\(age)",
//            "gender" : petInfo.gender ?? "",
//            "weight" : petInfo.weight ?? "",
//            "birthdate" : "\(birthdate.toDate().timeIntervalSince1970)"
//        ]
//        print("para ==\(para)")
        //        NetWork.request(target: .bindPet(parameters: para)) { response in
        //
        //        } error: { code in
        //
        //        } failure: { error in
        //
        //        }
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    private func cellSelect(_ indexPath:IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("昵称")
            break
        case 1:
            
            let vc = KindViewController()
            vc.selectKind = { [weak self] kind in
                print("kind==\(kind)")
                self?.petInfo.breed = kind
                self?.vue.updatePetModel(self?.petInfo)
                
            }
            navigationController?.pushViewController(vc, animated: true)
            
            break
        case 2,3,4,5:
            if let window = keyWindow() {
                
                
                let pickView = SelectDataAlertView(frame: window.bounds ,dataType:  SelectDateType(rawValue: indexPath.row) ?? .sex, value: vue.subTitles[indexPath.row])
                
                window.addSubview(pickView)
                
                
                pickView.confirmClick = { [weak self] value in
                    print("value ==\(value ?? "取消选择")")
                    
                    guard let selectedVaule = value else {return}
                    
                    self?.setData(indexPath, selectedVaule)
                }
            }
            break
            
            
            
        default:
            break
        }
        
        
        
        
    }
    
    
    func setData( _ index:IndexPath , _ value:String) {
        let type = SelectDateType(rawValue: index.row)
        
        vue.subTitles.updateValue(value, forKey: index.row)
        if type == .sex {
            petInfo.gender = value
        } else if type == .date {
            petInfo.birthdate = value
        }else if type == .weight {
            petInfo.weight = value
        } else if type == .life {
            petInfo.isLife = value
        }
        
        vue.updatePetModel(petInfo)
    }
    
    override func zNavigationBarBackgroundImage(_ navigationBar: ZBaseNavigationBar) -> UIImage {
        
        return UIImage.createImg(UIColor.white, with: navigationBar.bounds.size) ?? UIImage(named: "")!
    }
    
    
}
