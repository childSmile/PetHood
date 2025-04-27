//
//  HomeViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/17.
//

import UIKit
import RxSwift

class HomeViewController: ZBaseViewController {
    
    private lazy var tableView = UITableView(frame: view.bounds,style: .plain)
        .bgColor(.clear)
        .regCell(HomeTableViewCell.self)
        .dlgProxy(self)
        .dataProxy(self)
        .disabeiOS15NewFeatures()
        .sepStyle(.none)
        .scrollIndicator(false, vShow: true)
        .rowH(DHPXSW(s: 96))
        .footerVue(UIView())
//        .headerVue(UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: DHPXSW(s: 1)))
//        .footerVue(FooterView(frame: CGRect(x: 0, y: 0, width: view.width, height: DHPXSW(s: 30))))
    
    var loginButton = UIButton(type: .custom)
        .title("登录", for: .normal)
        .titleColor(.black, for: .normal)
    
    var chartButton = UIButton(type: .custom)
        .title("图表", for: .normal)
        .titleColor(.black, for: .normal)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    
   private  func setUI() {
//        loginButton.add2(view).lyt { make in
//            make.centerX.equalTo(view.snp.centerX)
//            make.top.equalTo(z_navgationBar.snp.bottom).offset(DHPXSW(s: 10))
//            make.height.equalTo(DHPXSW(s: 30))
//            make.width.equalTo(DHPXSW(s: 300))
//        }
//        
//        loginButton.rx.tap.subscribe { [weak self] event in
//            let vc = LoginViewController()
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }.disposed(by: disposeBag)
//       
//       chartButton.add2(view).lyt { make in
//           make.centerX.equalTo(view.snp.centerX)
//           make.top.equalTo(loginButton.snp.bottom).offset(DHPXSW(s: 10))
//           make.height.equalTo(DHPXSW(s: 30))
//           make.width.equalTo(DHPXSW(s: 300))
//       }
//       
//       chartButton.rx.tap.subscribe { [weak self] event in
//           let vc = ChartViewController()
//           self?.navigationController?.pushViewController(vc, animated: true)
//       }.disposed(by: disposeBag)
//       
//       
//       return;
//       tableView.add2(view).lyt { make in
//           make.top.equalTo(z_navgationBar.snp.bottom)
//           make.left.right.bottom.equalTo(0)
//       }
       
       
       
       let titles = ["登录" , "图表" , "蓝牙"]
       
       let sc = UIScrollView(frame: view.bounds)
       sc.add2(view).lyt { make in
           make.top.equalTo(DHPXSW(s: 100))
           make.left.right.bottom.equalTo(0)
       }
       
       for (i,v) in titles.enumerated() {
           let btn = UIButton(type: .custom)
               .title("\(v)", for: .normal)
               .titleColor(UIColor(rgb: 0x000000), for: .normal)
               .bgColor(UIColor(rgb: 0xffffff))
               .titleFont(UIFont.systemFont(ofSize: 14, weight: .light))
           
           btn.add2(sc).lyt { make in
               make.top.equalTo(DHPXSW(s: (CGFloat(i) * 60)))
               make.left.equalTo(DHPXSW(s: 20))
//               make.right.equalTo(DHPXSW(s: -20))
               make.width.equalTo(DHPXSW(s: 200))
               make.height.equalTo(48)
           }
           btn.tag = i
           btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
           
       }
       
       
       
    }
    
    @objc func btnAction(_ sender:UIButton) {
        let tag = sender.tag
        if tag == 0 {
            let vc = LoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        if tag == 1 {
            let vc = ChartViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        if tag == 2 {
            let vc = BlueViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    override func zNavigationBarRightView(_ navigationBar: ZBaseNavigationBar) -> UIView {
        return UIView()
    }

    

}



extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(HomeTableViewCell.self, for: indexPath) 
        
        cell.configItem(item: "", indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}
