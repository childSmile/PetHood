//
//  ActivityViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/10.
//

import UIKit
import AMapNaviKit
import RxSwift
import AMapSearchKit
import RxCocoa
import Toast_Swift

class ActivityViewController: ZBaseViewController {
    
    private var mapView: MAMapView!
    private var mapManager = MapManager()
    private var petAnnotations = Array<PetMAPointAnnotation>()
    private var currentIndex = 0
    private var scrollerView = UIScrollView()
    private var pageControl =  WOPageControl() //JJPageControl()
    private var itemViews : [MenuView] = []
    private var menuView:MenuView!
    private var lightVue = SwitchVue(frame: .zero)
    
    
    private let cardW =  DHPXSW(s: 335)
//    private var coordinates: [CLLocationCoordinate2D] = []
    /*
    CLLocationCoordinate2D(latitude: 30.149144000000007, longitude: 120.27036799999996),
    CLLocationCoordinate2D(latitude: 30.187541000000003, longitude: 120.16738599999996),
    CLLocationCoordinate2D(latitude: 30.254635000000007, longitude: 120.16404699999998),
     */
    
    private var petModels:[PetLocationModel] = []
    private var mapDeviceModels:[MapDeviceModel] = []
  
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ActivityViewModel.manager.getHomeDeviceList {[weak self] res in
            self?.mapDeviceModels = res as! [MapDeviceModel]
            self?.updateUI()
          
        }
    }
    
    
    func updateUI() {
        for model in self.mapDeviceModels {
            let coor = CLLocationCoordinate2D(latitude: model.gps_latitude as! CLLocationDegrees, longitude: model.gps_longitude as! CLLocationDegrees)
            mapManager.convertLocation(coor)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle = "定位"
        initMapManager()
        
    }
    
   
    private func initRx() {
        
          pageControl.valueChange = { [weak self] page in
              self?.changePage()
          }
          
          lightVue.tapClosure = {
              print("打开开关")
          }
          
          lightVue.isOnSubject.subscribe { [unowned self] isOn in
              print("灯光开关==\(isOn ? "开" : "关")")
              self.lightVue.relyt { make in
                  make.bottom.equalTo(scrollerView.snp.top).offset(DHPXSW(s: -20))
                  make.right.equalTo(DHPXSW(s: -16))
                  make.size.equalTo(CGSize(width: DHPXSW(s: 44), height: isOn ? DHPXSW(s: 60) : DHPXSW(s: 44)))
              }
              self.lightVue.bgColor(isOn ? UIColor.color(hex: 0xF5D738) : .white)
              
          }.disposed(by: disposeBag)
          
  
  
    }
    
    private func addPetLocation() {
        
        mapView.removeAnnotations(petAnnotations)
        petAnnotations.removeAll()
        
        for (idx, pet) in petModels.enumerated() {
            let anno = PetMAPointAnnotation()
            anno.coordinate = pet.coor
            anno.title = String(idx)
            anno.isCurrent = idx == currentIndex
            petAnnotations.append(anno)
        }
        
        mapView.addAnnotations(petAnnotations)
        mapView.selectAnnotation(petAnnotations[currentIndex], animated: false)
        mapView.showAnnotations(petAnnotations, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 80, right: 80), animated: false)
        //        currentCircle = MACircle(center: petModels[currentIndex].coor, radius: DHPXSW(s: 100))
        //        mapView.add(currentCircle)
        
        //        intVariable.onNext(currentIndex)
        setCurrentMenuView()
        
        
    }
   
    private func changePage() {
        print("changePage")
        let x = cardW * CGFloat(pageControl.currentPage)
        scrollerView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        currentIndex = pageControl.currentPage
        addPetLocation()
    }
    
    private func setCurrentMenuView() {
        
        menuView = itemViews[currentIndex]
        
        menuView.tapClick = { [weak self] type in
            print(type)
            
            self?.tapAction(type: type)
            
        }
        
        
    }
    
    private func tapAction(type:PetActivity) {
        
        let pet = petModels[currentIndex]
//        if(!pet.online && type != .TrackPet) {
//            view.toast("当前设备已离线，请连接后操作当前设备已离线，请连接后操作" )
//            return
//        }
                
        switch type {
        case .WalkPet:
            let vc = WalkViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .LookforPet:
            
            let lav = CustomAlertView(
                frame: CGRect(x: 0, y: 0, width: DHPXSW(s: 308), height: DHPXSW(s: 330)),
                title: "寻宠模式",
                message: "设备将调用一切数据全力协助您找回「霸总莱德」。寻宠模式开启后将保持打开，直至您手动关闭！",
                tip: "*此模式下功耗较大，当前电量可维持20分钟",
                topImage: "lookfor_alert_top_image",
                okTitle: "开启寻宠" ,
                cancelTitle: "取消"
            )
            lav.show()
            
            lav.okClosure = { [weak self] in
                
                let  vc = LookforViewController()
                vc.petAnnotation = self?.petAnnotations[self!.currentIndex]
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .TripPet:
            
            let lav = CustomAlertView(
                frame: CGRect(x: 0, y: 0, width: DHPXSW(s: 308), height:DHPXSW(s: 310)),
                title: "宠物出行",
                message: "在线查轨迹，出行路径实时看，环境温度检测，让爱宠更舒适",
                tip: "*此模式下功耗较大，当前电量可维持20分钟",
                topImage: "walk_alert_top_image",
                okTitle: "开启" ,
                cancelTitle: "取消"
            )
            lav.show()
            
            lav.okClosure = { [weak self] in
                
                let vc = TripViewController()
                vc.petModel = self?.petModels[self!.currentIndex]
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .TrackPet:
            let vc = TrackViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func alertAuth(status:CLAuthorizationStatus ) {
        
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            let lav = CustomAlertView(
                frame: CGRect(x: 0, y: 0, width: DHPXSW(s: 308), height: PHDHPXscaleH(266)),
                title: "开启位置服务访问",
                message: "获得位置权限，为您获得更准确的宠物位置，请在系统设置中开启位置服务",
                //                    tip: nil,
                //                    topImage: nil,
                okTitle: "开启",
                cancelTitle: "取消"
            )
            lav.show()
            lav.okClosure = {
                print("去开启")
            }
        }
    }
    
    deinit {
        print("\(self) ===deinit")
    }
    
    
    
}

extension ActivityViewController : UIScrollViewDelegate {
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        print(scrollView.contentOffset.x / cardW)
        
        let pageIndex = Int(scrollView.contentOffset.x / cardW)
        pageControl.currentPage = pageIndex
        currentIndex = pageIndex
        addPetLocation()
    }
    
}

extension ActivityViewController : MapMangerDelegate {
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        print(response.regeocode.formattedAddress ?? "")
        
        petModels.append(
            PetLocationModel(
                regeocode: response.regeocode,
                coor: CLLocationCoordinate2D(latitude: request.location.latitude, longitude: request.location.longitude),
                location: request.location ,
                mapDeviceModel: modelWithCoor(request.location.latitude, request.location.longitude) 
            )
        )
        
        if petModels.count == self.mapDeviceModels.count {
            
            initUI()
            
            addPetLocation()
        }
    }
    
    func mapView(_ mapView: MAMapView, didSelect view: MAAnnotationView) {
        if(view.isKind(of: PetAnnotationView.self)) {
            print("PetMAPointAnnotation")
            for (idx ,point) in petAnnotations.enumerated() {
                if point.isEqual(view.annotation) {
                    if currentIndex == idx {
                        return
                    }
                    currentIndex = idx
                }
            }
            
            pageControl.currentPage = currentIndex;
            self.changePage()
            
            
            return
        }
    }
    
    func mapView(_ mapView: MAMapView, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        mapView .selectAnnotation(petAnnotations[currentIndex], animated: false)
    }
    
    func locationManager(_ manager: AMapLocationManager, didChange status: CLAuthorizationStatus) {
        
    }
    
}


//UI
extension ActivityViewController {
    
    private func initMapManager() {
        mapManager.delegate = self
        alertAuth(status: mapManager.authStatus)
        mapView = mapManager.mapView
        mapView.add2(view).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    
    
    private func initUI() {
        print("initUI")

        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: view.height - tabbarHeight() - DHPXSW(s: 40), width: view.width, height: DHPXSW(s: 50))
        layer.colors = [
            UIColor.color(hex: 0xE2E3E7).withAlphaComponent(0).cgColor ,
            UIColor.color(hex: 0xE2E3E7).withAlphaComponent(1).cgColor ,
        ]
        view.layer.addSublayer(layer)
        
        
        let space =  DHPXSW(s: 8.0)
        let count = petModels.count
        let h = DHPXSW(s: 187)
        
 
        scrollerView.add2(view)
            .lyt { make in
                make.bottom.equalTo(-(DHPXSW(s: 16) + tabbarHeight()))
                make.left.equalTo(DHPXSW(s: 16))
                make.right.equalTo(DHPXSW(s: -16))
                make.height.equalTo(h)
            }
//        scrollerView.frame = CGRect(x: DHPXSW(s: 16), y: (view.height - DHPXSW(s: 16) - tabbarHeight() - h), width: (view.width - 2 * DHPXSW(s: 16)), height: h)
        
        let w = cardW * CGFloat(count) + space * CGFloat(count - 1)
        
        let bgVue = UIView().frame(CGRect(x: 0, y: 0, width: w, height: h))
        scrollerView.addSubview(bgVue)
        
        scrollerView.contentSize  = CGSize(width: w , height: h)
        scrollerView.clipsToBounds = false
        scrollerView.isPagingEnabled = true
        scrollerView.delegate = self
        scrollerView.showsHorizontalScrollIndicator = false
        
        for idx in 0..<count {
            let vue = MenuView()
            vue.add2(bgVue)
            itemViews.append(vue)
            vue.configVue(pet: petModels[idx])
//            vue.frame = CGRect(x: CGFloat(idx) * (cardW + space), y: 0, width: cardW, height: h)

//            Observable.of(petModels[idx].online).subscribe(onNext: { [weak vue] on  in
//                print("babababba")
//                vue?.online = on
//            })
//            .disposed(by: disposeBag)
//            Observable.of(petModels[idx].online).bind(to: vue.rx.online).disposed(by: disposeBag)
            
        }
        itemViews.snp.distributeViewsAlong(axisType: .horizontal , fixedSpacing: space , leadSpacing: DHPXSW(s: 0) , tailSpacing: DHPXSW(s: 0))
        itemViews.snp.makeConstraints {
            $0.top.bottom.equalTo(0)
            $0.width.equalTo(cardW)
        }
        
        
        
        pageControl.add2(view).lyt { make in
            make.top.equalTo(scrollerView.snp.bottom).offset(5)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(10)
        }
        pageControl.center = CGPoint(x: pageControl.superview!.center.x, y: pageControl.center.y)
        
        pageControl.cornerRadius = 2;
        pageControl.dotHeight = 4;
        pageControl.dotSpace = 4;
        pageControl.currentDotWidth = 16;
        pageControl.otherDotWidth = 4;
        pageControl.otherDotColor = UIColor.white
        pageControl.currentDotColor = UIColor.color(hex: 0x1274FF)
        pageControl.numberOfPages = count
        
      
//        pageControl.numberOfPages = count
//        pageControl.currentPage = currentIndex
//        pageControl.currentColor = UIColor.color(hex: 0x1274FF)
//        pageControl.otherColor = UIColor.white
//        pageControl.pointCornerRadius = 2
//        pageControl.currentPointSize = CGSize(width: 16, height: 4)
//        pageControl.otherPointSize = CGSize(width: 4, height: 4)
//        pageControl.backgroundColor = .blue
//
//        pageControl.addTarget(self, action: #selector(changePage), for: .valueChanged)
        
        
        
        lightVue.add2(view).lyt { make in
            make.bottom.equalTo(scrollerView.snp.top).offset(DHPXSW(s: -20))
            make.right.equalTo(DHPXSW(s: -16))
            make.size.equalTo(CGSize(width: DHPXSW(s: 44), height: DHPXSW(s: 44)))
        }
        
        initRx()
        
    }
    
    private func modelWithCoor(_ latitude : CLLocationDegrees , _ longitude : CLLocationDegrees) -> MapDeviceModel? {
        for m in mapDeviceModels {
            if(m.gps_latitude?.doubleValue == latitude
            && m.gps_longitude?.doubleValue == longitude) {
                return m
            }
        }
        return nil
    }
    
    
}
