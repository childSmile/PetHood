//
//  LookforViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/10.
//

import UIKit

class LookforViewController: ZBaseViewController {

    var petAnnotation : PetMAPointAnnotation!
    private var mapManager = MapManager()
    private var menuView:MenuView = MenuView(type: .LookforPet)
    private var myPosition : CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = PetActivity.LookforPet.title + "模式"
        initMapManager()
        initUI()
        addPetLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            self?.addAlertView()
        }
        // Do any additional setup after loading the view.
    }
    
    private func initUI() {
        menuView.add2(view).lyt { make in
            make.left.equalTo(DHPXSW(s: 16))
            make.right.equalTo(DHPXSW(s: -16))
            make.bottom.equalTo(-(DHPXSW(s: 16)))
            make.height.equalTo(DHPXSW(s: 223))
        }
        menuView.naviClick = {[unowned self] in
            print("开始导航")
            self.routePlan()
        }
        
        menuView.closeClick = {
            print("关闭寻宠模式")
        }
    }
    
    private func routePlan() {
        guard let start = AMapNaviPoint.location(withLatitude:  myPosition.coordinate.latitude, longitude:  myPosition.coordinate.longitude) else { return  }
        guard let end = AMapNaviPoint.location(withLatitude:  petAnnotation.coordinate.latitude, longitude:  petAnnotation.coordinate.longitude) else { return  }
      
        mapManager.routePlanStart(start, end: end ,type: .init(rawValue: WalkNaviRoutePlan.rawValue))
    }
    
    private func initMapManager() {
        mapManager.delegate = self
        mapManager.mapView.add2(view).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
    }
    
    private func addPetLocation() {
        self.mapManager.mapView .addAnnotation(petAnnotation)
        self.mapManager.mapView.selectAnnotation(petAnnotation, animated: true)
    }
    private func addAlertView() {
        let height = DHPXSW(s: 40)
        let width = DHPXSW(s: 100)
        let vue = UIView().bgColor(.white).frame(CGRect(x: 0, y: 0, width: width, height: height))
        
        let annoView = self.mapManager.currentPetView as! CurrentPetAnnotationView
        
        vue.center = CGPoint(x: annoView.centerX , y: annoView.origin.y -  DHPXSW(s: 77) - height / 2 )
        vue.add2(view)
        
        
        let p1 = MAMapPointForCoordinate(petAnnotation.coordinate)
        let p2 = MAMapPointForCoordinate(myPosition.coordinate)
        
        let distance =  MAMetersBetweenMapPoints(p1, p2)
        
        let label = UILabel().txt("距离您\(String(format: "%.1f", distance / 1000))千米").txtColor(.black).alignment(.center).txtFont(UIFont.systemFont(ofSize: 10, weight: .light))
        label.add2(vue).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    

}


extension LookforViewController : MapMangerDelegate , DriveNaviViewControllerDelegate  {
    
    func didUpdateUserLocation(_ location: CLLocation) {
        myPosition = location
    }
    
    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
        print("开车路径规划完成，开始导航")
        let driNaviVC = DriveNaviViewController()
        driNaviVC.delegate = self
        driveManager.addDataRepresentative(driNaviVC.driveView)
        navigationController?.pushViewController(driNaviVC, animated: false)
        
        driveManager.startEmulatorNavi()
    
    }
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        
        print("步行路径规划完成，开始导航")
        let walkNaviVC = WalkNaviViewController()
//        walkNaviVC.delegate = self
        walkManager.addDataRepresentative(walkNaviVC.walkView)
        navigationController?.pushViewController(walkNaviVC, animated: false)
        
        walkManager.startEmulatorNavi()
    }
    
    
    func driveNaviViewCloseButtonClicked() {
        print("结束导航")
        AMapNaviDriveManager.sharedInstance().stopNavi();
        navigationController?.popViewController(animated: false)
    }
}

