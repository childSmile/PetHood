//
//  TrackViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/10.
//

import UIKit

class TrackViewController: ZBaseViewController {
    
    var petModel : PetLocationModel!
    private lazy var tableView = UITableView(frame: view.bounds,style: .grouped)
        .bgColor(.clear)
        .regCell(PetTrackTableViewCell.self)
        .dlgProxy(self)
        .dataProxy(self)
        .disabeiOS15NewFeatures()
        .sepStyle(.none)
        .scrollIndicator(false, vShow: true)
//        .headerVue(UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: DHPXSW(s: 1)))
        .footerVue(FooterView(frame: CGRect(x: 0, y: 0, width: view.width, height: DHPXSW(s: 30))))
        
    private var emptyView = EmptyView(frame: .zero).hidden(true)

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = PetActivity.TrackPet.title
//        view.backgroundColor = UIColor.color(hex: 0xf6f6f6)
        addAllSubviews()
    }
    
    private func addAllSubviews() {
        tableView.add2(view).lyt { make in
            make.top.equalTo(PHNavBarHeight())
            make.left.right.bottom.equalTo(0)
        }
        
        emptyView.add2(view).lyt { make in
            make.top.equalTo(PHNavBarHeight())
            make.left.right.bottom.equalTo(0)
        }
//        tableView.isHidden = true
        emptyView.config("report_empty", "暂无记录")
    }
  
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    deinit {
        
        print("\(self) ===deinit")
    }


}


extension TrackViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(PetTrackTableViewCell.self, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let bgVue = SectionHeaderView(frame: .zero)
        bgVue.config("\(section + 3)")
        return bgVue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DHPXSW(s: 40)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("进入详情")
        let vc = TrackDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > PHNavBarHeight() {
            z_navgationBar.backgroundImage = UIImage.createImg(.white, with: z_navgationBar.bounds.size)!
        } else {
            //return [UIColor gradientColorImageFromColors:@[[UIColor colorWithRGBA:0x0075FFff] , [UIColor colorWithRGBA:0x0075FF00]] gradientType:GradientTypeTopToBottom imgSize:navigationBar.frame.size];
            z_navgationBar.backgroundImage = UIColor.gradientColorImage(fromColors: [UIColor(rgba: 0x0075FFff) , UIColor(rgba: 0x0075FF00)], gradientType: .topToBottom, imgSize: z_navgationBar.bounds.size)
        }
    }
    
}

extension TrackViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  4
    }
}



class  FooterView: UIView {
    
    private var label = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 12, weight: .light))
        .txtColor(UIColor.color(hex: 0x999999))
        .txt("仅保留近一个月的历史轨迹")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SectionHeaderView:UIView {
    
    private var dayLabel = UILabel()
//        .txtFont(UIFont.systemFont(ofSize: 12, weight: .light))
//        .txtColor(UIColor.color(hex: 0x999999))
//        .txt("仅保留近一个月的历史轨迹")
//    private var monthLabel = UILabel()
//        .txtFont(UIFont.systemFont(ofSize: 12, weight: .light))
//        .txtColor(UIColor.color(hex: 0x999999))
//        .txt("仅保留近一个月的历史轨迹")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        let dayLabel = UILabel()
//            .attrTxt(att)
//            .txtFont(UIFont.systemFont(ofSize: 28, weight: .bold))
//            .txtColor(.black)
//            .txt("\(section + 3)")
        
//        let monthLabel = UILabel()
//            .txtFont(UIFont.systemFont(ofSize: 16, weight: .bold))
//            .txtColor(.black)
//            .txt("7月")
        
        dayLabel.add2(self).lyt { make in
            make.left.equalTo(DHPXSW(s: 20))
            make.centerY.equalTo(self.snp.centerY)
        }
        
//        monthLabel.add2(bgVue).lyt { make in
//            make.left.equalTo(dayLabel.snp.right).offset(2)
//            make.centerY.equalTo(bgVue.snp.centerY)
//        }
        
    }
    
    func config(_ date:String) {
        

        let att = NSMutableAttributedString(
            string: date,
            attributes: [.font : UIFont.systemFont(ofSize: 28, weight: .bold) , .foregroundColor:UIColor.color(hex: 0x000000)])
        att.append(NSAttributedString(string: "7月",
                                      attributes: [.font:UIFont.systemFont(ofSize: 16, weight: .bold) , .foregroundColor:UIColor.color(hex: 0x000000)]))
        
        dayLabel.attrTxt(att)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class EmptyView:UIView {
    private var img = UIImageView()
    private var label = UILabel().txtFont(UIFont.systemFont(ofSize: 14, weight: .light)).txtColor(UIColor.color(hex: 0x999999))
    override init(frame: CGRect) {
        super.init(frame: frame)
        img.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        label.add2(self).lyt { make in
            make.top.equalTo(img.snp.bottom).offset(DHPXSW(s: 4))
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func config(_ image:String , _ title:String) {
        label.txt(title)
        img.img(UIImage(named: image))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
