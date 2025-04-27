//
//  TripViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/10.
//

import UIKit
import Toast_Swift


class TripViewController: ZBaseViewController {

    var petModel : PetLocationModel!
    private var mapManager = MapManager()
    var timer = Timer()
    var points:[AMapNaviPoint] = []
    var index = 0
    var nowPoints:[AMapNaviPoint] = []
    var menuView = MenuView(type: .TripPet)
    var searvhView  = InputSearchEndView()
    var petAnnotations:[PetMAPointAnnotation] = []
    var mapView : MAMapView!
    
    //关键字搜索结果
    var poiAnnotations:[POIAnnotation] = []
    
    var startPoint : AMapNaviPoint?
    var endPoint : AMapNaviPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = PetActivity.TripPet.title + "模式"
        
        
        startPoint = AMapNaviPoint.location(withLatitude: petModel.location.latitude, longitude: petModel.location.longitude)
        

        initMapManager()
        initUI()
        
        addPetLocation()
        
        //模拟出行模式
//        initTimer()
        addPetPath()
    
    }
    
    private func addPetLocation() {
        

        let anno = PetMAPointAnnotation()
        anno.coordinate = petModel.coor
        anno.title = petModel.showLocation
        anno.isCurrent = true
        petAnnotations.append(anno);
    
        mapView.addAnnotations(petAnnotations)
        mapView.setCenter(petModel.coor, animated: true)
        mapView.selectAnnotation(petAnnotations.first, animated: false)
//        guard let start = startPoint else {return}
//        let startAnnotation = MAPointAnnotation();
//        startAnnotation.coordinate = CLLocationCoordinate2D(latitude: 30.149144000000007, longitude: 120.27036799999996)
//        startAnnotation.title      = "起点";
//        mapView.addAnnotation(startAnnotation)
        //            self?.mapManager.addDefaultAnnotations(start, end: end)
    }
    
    private func initUI() {
        menuView.add2(view).lyt { make in
            make.left.equalTo(DHPXSW(s: 16))
            make.right.equalTo(DHPXSW(s: -16))
            make.bottom.equalTo(-(DHPXSW(s: 16)))
            make.height.equalTo(DHPXSW(s: 259))
        }
        
        menuView.inputClick = { [weak  self] in
            print("inputClick")
            self?.alertInputView()
            
        }
        menuView.naviClick = {[weak  self] in
            self?.startTrip()
        }
        menuView.stopTripClick = { [weak self] in
            print("结束")
            self?.navigationController?.popViewController(animated: true)
        }
        
        menuView.updateStartPoint(location: petModel.showLocation)
        menuView.configVue(pet: petModel)
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0 is UIWindowScene})
            .map({($0 as! UIWindowScene).windows})
            .first?.first(where: {$0.isKeyWindow}) {
            // 使用keyWindow
            searvhView.add2(keyWindow).lyt { make in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0)
            }
            
            searvhView.location = petModel.location
            
            searvhView.backClick = { [weak  self] in
                self?.closeInputView()
            }
            
            searvhView.desClick = { [weak self] des in
                self?.addDesLocation(des)
                self?.closeInputView()
            }
            
//            searvhView.searchClick = { [weak  self] value in
//                print("搜索关键字\(value)")
//                self?.searchLocation(location: value)
//                self?.closeInputView()
//            }
            
        }
    
        
    }
    
    private func addDesLocation(_ des:POIAnnotation) {
        //移除之前搜索显示
        mapView.removeAnnotations(poiAnnotations)
        poiAnnotations.removeAll()
        
        menuView.updateEndPoint(location: des.poi.name)
        
        endPoint = AMapNaviPoint.location(withLatitude: des.coordinate.latitude, longitude: des.coordinate.longitude)
        
        poiAnnotations.append(des)
        
        //显示在地图上
        mapView.addAnnotations(poiAnnotations)
        
     
    }
    
    private func startTrip() {
        print("开始规划路线");
        guard let start = startPoint,
              let end = endPoint else {
            view.toast("请选择正确的起点和终点")
            return
        }
        
        //移除搜索点
        mapView.removeAnnotations(poiAnnotations)
        
        //规划路线 1 开车
        mapManager.routePlanStart(start, end: end, type: MapNaviRoutePlanType(DriveNaviRoutePlan.rawValue))
        
        menuView.relyt({ make in
            make.left.equalTo(DHPXSW(s: 16))
            make.right.equalTo(DHPXSW(s: -16))
            make.bottom.equalTo(-(DHPXSW(s: 16)))
            make.height.equalTo(DHPXSW(s: 152))
        })
        //修改UI
        menuView.startTrip()
        
        initTimer()
        
    }
    
    
     private func searchLocation(location:String){
         let request = AMapPOIKeywordsSearchRequest()
         request.keywords = location;
         request.location = petModel.location
         mapManager.search(withRequest: request)
         
         
    }
    
    private func closeInputView() {
        UIView.animate(withDuration: 0.5) { [unowned  self] in
            
            searvhView.relyt { make in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0)
            }
        }completion: { [unowned  self] _ in
            searvhView.dismiss()
        }
    }
    
    private func alertInputView() {
        UIView.animate(withDuration: 0.5) { [unowned  self] in
            
            searvhView.relyt { make in
                make.left.top.right.bottom.equalTo(0)
            }
        }completion: {[unowned  self]  _ in
            searvhView.show()
        }
    }
    
    private func initMapManager() {
        mapManager.delegate = self
        mapManager.mapView.add2(view).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        mapView = mapManager.mapView
    }
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    private func addPetPath() {
        let polyString = "120.167602,30.187795;120.167534,30.187838;120.167389,30.188015;120.167346,30.188069;120.167228,30.188584;120.167056,30.189104;120.167056,30.189104;120.166482,30.188959;120.166316,30.188906;120.166316,30.188906;120.166295,30.188825;120.166284,30.188696;120.166686,30.187334;120.166686,30.187334;120.166557,30.18727;120.166305,30.187157;120.166305,30.187157;120.166289,30.187216;120.166268,30.187296;120.165683,30.189313;120.165522,30.189313;120.166257,30.186776;120.166643,30.185397;120.166697,30.18521;120.166868,30.18462;120.167067,30.183917;120.167223,30.183364;120.167346,30.182967;120.167528,30.182361;120.167593,30.182055;120.16762,30.181841;120.167641,30.181503;120.167641,30.181095;120.167636,30.18028;120.167625,30.179443;120.167625,30.179421;120.16763,30.179014;120.167593,30.176889;120.167485,30.175757;120.167394,30.174958;120.167244,30.173692;120.167523,30.17351;120.168456,30.173504;120.169046,30.173494;120.169803,30.173381;120.170634,30.173343;120.170634,30.173343;120.171316,30.173295;120.172158,30.173285;120.173392,30.173268;120.173778,30.173285;120.174298,30.173338;120.174465,30.173349;120.17476,30.17336;120.1752,30.173376;120.175242,30.173397;120.175318,30.17344;120.177013,30.173365;120.179866,30.173236;120.18102,30.173183;120.181202,30.173177;120.181728,30.17315;120.18271,30.173097;120.183295,30.17307;120.183879,30.173043;120.184426,30.173016;120.185317,30.172979;120.185655,30.172963;120.186706,30.172914;120.188975,30.172823;120.189667,30.172823;120.190429,30.17285;120.190595,30.172855;120.191207,30.172898;120.192811,30.173038;120.193015,30.173054;120.197054,30.173418;120.197542,30.17344;120.198041,30.17344;120.198605,30.173413;120.199264,30.173354;120.203942,30.172914;120.204768,30.172839;120.205235,30.172791;120.205701,30.172743;120.207697,30.172544;120.209419,30.172405;120.210648,30.172287;120.211018,30.172255;120.211452,30.172233;120.211876,30.172228;120.212402,30.172249;120.214746,30.172346;120.220518,30.172598;120.221795,30.172641;120.222449,30.17263;120.223115,30.172555;120.223404,30.172506;120.224043,30.172346;120.224772,30.172142;120.225099,30.172051;120.225652,30.171895;120.225652,30.171895;120.225781,30.17175;120.226161,30.171616;120.226655,30.171471;120.226655,30.171471;120.226832,30.171375;120.227256,30.171208;120.22857,30.170913;120.229262,30.170752;120.229262,30.170752;120.229643,30.170758;120.230614,30.17057;120.230973,30.170506;120.231343,30.170463;120.232572,30.170329;120.2335,30.170307;120.234171,30.170296;120.234375,30.170291;120.234879,30.17027;120.235656,30.17027;120.23747,30.170323;120.239202,30.170334;120.240705,30.170339;120.240705,30.170339;120.24071,30.169926;120.240747,30.169395;120.240833,30.168746;120.240871,30.168456;120.240892,30.168338;120.241075,30.167866;120.241101,30.167786;120.241182,30.167636;120.241375,30.167416;120.242072,30.16674;120.242276,30.166568;120.242464,30.166418;120.243311,30.16593;120.243531,30.165769;120.243875,30.165415;120.244143,30.16512;120.244416,30.164712;120.244535,30.164578;120.244599,30.164508;120.244851,30.164218;120.245543,30.163559;120.246916,30.162303;120.246916,30.162303;120.246353,30.161944;120.246203,30.161831;120.245801,30.161504;120.245398,30.161129"
       let polyString2 = "120.160183,30.184789;120.160233,30.184829;120.160249,30.184898;120.160243,30.184952;120.160217,30.184984;120.159986,30.185049;120.159986,30.185049;120.160115,30.185118;120.160163,30.185161;120.160163,30.185161;120.160018,30.185488;120.160018,30.185488;120.160447,30.185558;120.160989,30.185649;120.161391,30.185719;120.161563,30.185746;120.161826,30.185789;120.162373,30.185885;120.163602,30.186148;120.163666,30.186159;120.163773,30.186186;120.164036,30.18624;120.164884,30.186427;120.165045,30.186465;120.165447,30.186561;120.166257,30.186776;120.166257,30.186776;120.166643,30.185397;120.166853,30.185263;120.168145,30.185821;120.168456,30.185971;120.168998,30.18624;120.170018,30.186679;120.170656,30.186953;120.171257,30.187168;120.171632,30.187328;120.17204,30.187473;120.172169,30.187521;120.173199,30.188042;120.173343,30.18809;120.174819,30.188691;120.175972,30.189185;120.17698,30.189608;120.178488,30.190247;120.178917,30.190429;120.179116,30.190515;120.179845,30.190821;120.180398,30.19103;120.180543,30.191089;120.182533,30.192001;120.182742,30.192097;120.182887,30.192146;120.18382,30.192548;120.18382,30.192548;120.184024,30.192596;120.185376,30.193186;120.185376,30.193186;120.185762,30.193288;120.18595,30.19331;120.186095,30.19331;120.186288,30.193288;120.186449,30.193245;120.18661,30.193186;120.186771,30.193101;120.186813,30.193074;120.18691,30.193004;120.187033,30.192897;120.187135,30.192784;120.187226,30.192645;120.187355,30.192435;120.187425,30.192285;120.187597,30.191829;120.187704,30.191271;120.18772,30.191228;120.187774,30.191164;120.187838,30.190837;120.187913,30.190429;120.187929,30.190354;120.188256,30.188659;120.188439,30.187527;120.188503,30.186964;120.188568,30.186358;120.188584,30.186078;120.188605,30.185757;120.188611,30.184941;120.188578,30.18389;120.188568,30.183321;120.188498,30.182045;120.188493,30.181326;120.188439,30.179443;120.188423,30.178799;120.188433,30.178472;120.188433,30.178365;120.188428,30.178263;120.188428,30.178263;120.188262,30.177796;120.188203,30.177463;120.188176,30.177238;120.188101,30.17668;120.188069,30.176299;120.188047,30.175655;120.187978,30.175114;120.187978,30.175114;120.188015,30.17477;120.18802,30.174545;120.187999,30.17432;120.187994,30.174245;120.187951,30.174051;120.187881,30.173875;120.187623,30.173413;120.18757,30.173295;120.187538,30.173172;120.187521,30.173065;120.187521,30.172995;120.187532,30.172909;120.187559,30.172807;120.187591,30.172721;120.18764,30.172635;120.187709,30.172544;120.187843,30.172421;120.187929,30.172362;120.188069,30.172297;120.188208,30.172255;120.188358,30.172228;120.18846,30.172228;120.188578,30.172233;120.188734,30.172265;120.188943,30.172324;120.189565,30.17255;120.189903,30.172651;120.190236,30.172716;120.190429,30.172743;120.19051,30.172753;120.191121,30.172807;120.191201,30.172801;120.19125,30.172786;120.192113,30.172887;120.192548,30.172936;120.192945,30.172989;120.192961,30.172995;120.193015,30.173054;120.197054,30.173418;120.197542,30.17344;120.198041,30.17344;120.198605,30.173413;120.199264,30.173354;120.203942,30.172914;120.204768,30.172839;120.205235,30.172791;120.205701,30.172743;120.207697,30.172544;120.209419,30.172405;120.210648,30.172287;120.211018,30.172255;120.211452,30.172233;120.211876,30.172228;120.212402,30.172249;120.214746,30.172346;120.220518,30.172598;120.221795,30.172641;120.222449,30.17263;120.223115,30.172555;120.223404,30.172506;120.224043,30.172346;120.224772,30.172142;120.225099,30.172051;120.225652,30.171895;120.228672,30.171031;120.229493,30.170822;120.230426,30.170634;120.230984,30.170543;120.231451,30.170479;120.23202,30.17042;120.232813,30.170371;120.234375,30.170371;120.238709,30.170388;120.240238,30.170404;120.240924,30.170382;120.241708,30.170329;120.242142,30.17028;120.242775,30.170184;120.243773,30.170034;120.244685,30.169932;120.245189,30.1699;120.246187,30.169867;120.246187,30.169867;120.247018,30.169856;120.247555,30.169808;120.248,30.169749;120.248418,30.169674;120.248805,30.169583;120.24962,30.169352;120.252769,30.168456;120.25447,30.167979;120.254888,30.167898;120.255408,30.167823;120.256127,30.16777;120.256347,30.16777;120.256476,30.16777;120.257071,30.167818;120.257425,30.167866;120.257425,30.167866;120.257989,30.167898;120.258455,30.168011;120.258879,30.168145;120.259442,30.168344;120.259689,30.168408;120.25999,30.168451;120.260301,30.16844;120.261679,30.168161;120.261894,30.168102;120.262012,30.168054;120.262318,30.16785;120.262393,30.167743;120.262489,30.16755;120.262988,30.166413;120.263289,30.165667;120.263342,30.165334;120.263391,30.164916;120.263396,30.164787;120.263369,30.164218;120.263294,30.163462;120.263171,30.162604;120.263187,30.162395;120.263069,30.16196;120.263004,30.161697;120.262838,30.160909;120.262725,30.160276;120.262554,30.15946;120.262425,30.158758;120.262425,30.158645;120.262194,30.157653;120.262157,30.15747;120.261915,30.156231;120.261835,30.155818;120.261835,30.155818;120.262543,30.155829;120.263069,30.155823;120.263648,30.155818;120.264474,30.155807;120.265204,30.155807;120.265204,30.155807;120.265209,30.155442;120.265204,30.154847;120.265204,30.154316;120.265257,30.154042;120.265359,30.153683;120.265842,30.152508;120.266073,30.1521;120.266185,30.151961;120.266314,30.151886;120.266448,30.151832;120.266845,30.151795;120.267494,30.151768;120.267661,30.151741;120.26875,30.151762;120.269608,30.151778;120.269823,30.151778;120.27067,30.151762;120.271663,30.151752;120.271813,30.151752;120.272483,30.151746;120.272483,30.151746;120.27251,30.149778;120.272521,30.14967;120.272531,30.149365;120.272548,30.149107;120.272553,30.149026;120.272553,30.149026;120.272456,30.149021;120.272086,30.14901;120.270375,30.148957"
        let array = polyString.components(separatedBy: ";")
        print(array)
        
        for location in array {
            let temp : [String] = location.components(separatedBy: ",")
            guard let latitude = Double(temp.last ?? "nil" ) ,
                  let longitude = Double(temp.first ?? "nil") else {return}
            points.append(AMapNaviPoint.location(withLatitude: latitude, longitude: longitude))
        }
        
        print(points)
       
    }
   
    
   @objc func timerAction() {
       print("Timer fired!")
       
       nowPoints.append(points[index])
       mapManager.drawPath(nowPoints)
    
       let start = points[index]
       guard let end = self.endPoint else { return  }
       mapManager.routePlanStart(start, end: end,type: .init(DriveNaviRoutePlan.rawValue))
       
       
       mapView.removeAnnotations(petAnnotations)
       petAnnotations.removeAll()
       
       let anno = PetMAPointAnnotation()
       anno.coordinate = CLLocationCoordinate2D(latitude: start.latitude, longitude: start.longitude)
       anno.title = petModel.showLocation
       anno.isCurrent = true
       petAnnotations.append(anno);
       mapView.addAnnotations(petAnnotations)
       mapView.selectAnnotation(petAnnotations.first, animated: false)
       addAlertView()
       
       index = index + 5
       if(index >= points.count) {
           navigationController?.popViewController(animated: true)
       }
       
   }
    
    /// <#Description#>
    private func addAlertView() {
        
        let start = points[index]
        guard let end = self.endPoint else { return  }
        
        let height = DHPXSW(s: 56)
        let annoView = self.mapManager.currentPetView as! CurrentPetAnnotationView
        
        var vue = (view.viewWithTag(100) as? TripAlertView)
        if(vue == nil) {
            vue = TripAlertView(frame: .zero)
                .bgColor(.white)
                .cornerRadius(DHPXSW(s: 28))

            vue!.tag = 100
            view.addSubview(vue!)
           
        }

        vue?.relyt({ make in
            make.center.equalTo(CGPoint(x: annoView.centerX , y: annoView.origin.y -  DHPXSW(s: 80) - height / 2 ))
            make.height.equalTo(height)
        })
        vue!.config(start, end, "\(Int.random(in: 20...30))")
      
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        
    }
    deinit {
        print("\(self) ===deinit")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TripViewController : MapMangerDelegate {
    
//    func mapView(_ mapView: MAMapView, didSelect view: MAAnnotationView) {
//        if(view.annotation.isKind(of: POIAnnotation.self)) {
//            let p = view.annotation as! POIAnnotation
//            print("选中===\(String(describing: p.poi.formattedDescription()))");
//            menuView.updateEndPoint(location: p.poi.name)
//            endPoint = AMapNaviPoint.location(withLatitude: p.coordinate.latitude, longitude: p.coordinate.longitude)
//            mapView.selectAnnotation(petAnnotations.first, animated: false)
//        }
//    }
    func didUpdateUserLocation(_ location: CLLocation) {
        
    }
    
    func mapView(_ mapView: MAMapView, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        mapView.selectAnnotation(petAnnotations.first, animated: false)
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
       
    }
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest, response: AMapPOISearchResponse) {
        if(response.pois.count == 0) {
            print("没有搜索到");
            return;
        }
        //解析POI信息
        for (_,obj) in response.pois.enumerated() {
            poiAnnotations.append(POIAnnotation(poi: obj))
        }
        //显示在地图上
        mapView.addAnnotations(poiAnnotations)

//        if(poiAnnotations.count == 1) {
//            [self.mapView setCenterCoordinate:[poiAnnotations.firstObject coordinate] animated:YES];
//        }else {
//            [self.mapView showAnnotations:poiAnnotations animated:NO];
//            [self.mapView showAnnotations:poiAnnotations edgePadding:UIEdgeInsetsMake(DHPX(100), DHPX(10), DHPX(200), DHPX(10)) animated:YES];
//        }
        
        
        
    }
//    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
//        print("开车路径规划完成，开始导航")
//        let driNaviVC = DriveNaviViewController()
//        driNaviVC.delegate = self
//        driveManager.addDataRepresentative(driNaviVC.driveView)
//        navigationController?.pushViewController(driNaviVC, animated: false)
//        
//        driveManager.startEmulatorNavi()
//    }
}


extension TripViewController : DriveNaviViewControllerDelegate {
    func driveNaviViewCloseButtonClicked() {
        print("结束导航")
        AMapNaviDriveManager.sharedInstance().stopNavi();
        navigationController?.popViewController(animated: false)
        
    }
}


class TripAlertView:UIView {
    
    private var textLabel = UILabel().lines(2).alignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        textLabel.add2(self).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: DHPXSW(s: 16), bottom: 0, right: DHPXSW(s: 16)))
        }
    }
    
    func config(_ start:AMapNaviPoint , _ end:AMapNaviPoint ,_ temp:String) {
        
        let p1 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: start.latitude, longitude: start.longitude))
        let p2 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: end.latitude, longitude: end.longitude))
        
        let distance =  MAMetersBetweenMapPoints(p1, p2)
        
        let att = NSMutableAttributedString()
        let temp1 = NSAttributedString(string: "环境温度", attributes: [.foregroundColor:UIColor.color(hex: 0x999999) , .font:UIFont.systemFont(ofSize: 12, weight: .light)])
        att.append(temp1)
        
        let temp2 = NSAttributedString(string: "\(temp)度", attributes: [.foregroundColor:UIColor.color(hex: 0x000000) , .font:UIFont.systemFont(ofSize: 17, weight: .bold)])
        att.append(temp2)
        
        let temp3 = NSAttributedString(string: "\n距离目的地", attributes: [.foregroundColor:UIColor.color(hex: 0x999999) , .font:UIFont.systemFont(ofSize: 12, weight: .light)])
        att.append(temp3)
        
        let temp4 = NSAttributedString(string: "\(String(format: "%.1f", distance / 1000))千米", attributes: [.foregroundColor:UIColor.color(hex: 0x000000) , .font:UIFont.systemFont(ofSize: 17, weight: .bold)])
        att.append(temp4)
        
        textLabel.attrTxt(att)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

