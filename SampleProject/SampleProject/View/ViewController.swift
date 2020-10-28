//
//  ViewController.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- Variables
    fileprivate var country: Country?
    fileprivate var dataSource =  [CellInfo]()
    fileprivate var myTableView: UITableView?
    var networkMangaer:NetworkManager? = NetworkManager()
    
    //MARK:- View Life Cycle Metthods
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.networkMangaer?.delegate = self
        setNavigationButton()
        self.refreshTableView()
    }
    
    deinit {
        self.networkMangaer?.delegate = nil
        self.networkMangaer = nil
    }
    
    //MARK:- Custom Functions
    @objc func refreshTableView() {
        self.networkMangaer?.getTableDatat()
    }
    
    fileprivate func setNavigationButton() {
        DispatchQueue.main.async {
            let navButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(self.refreshTableView))
            self.navigationItem.setRightBarButtonItems([navButton], animated: true)
        }
    }

    fileprivate func initTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        myTableView = UITableView(frame: CGRect(x: 0, y: self.topbarHeight,
                                                width: displayWidth,
                                                height: displayHeight - self.topbarHeight))
        myTableView?.register(CustomImageCell.self, forCellReuseIdentifier: "cellID")
        
        myTableView?.dataSource = self
        myTableView?.delegate = self
        if let aView = self.myTableView {
            self.view.addSubview(aView)
        }
        
        myTableView?.tableFooterView = UIView()
        
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.navigationItem.title = self.country?.title ?? ""
            self.myTableView?.reloadData()
        }
    }
    
    func parseResponse(_ data: Country) {
        self.dataSource.removeAll()
        
        for info in data.rows {
            let aCellInfo = CellInfo ()
            aCellInfo.title = info.title ?? ""
            aCellInfo.description = info.description ?? ""
            aCellInfo.imageURL =  info.imageHref ?? ""
            self.dataSource.append(aCellInfo)
        }
    }
}

//MARK:- Table View Methods
extension ViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? CustomImageCell
        aCell?.cellData = self.dataSource[indexPath.row]
        
        aCell?.configureCelll()
        return aCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.getTableHeightFor(indexPath.row)
        return height
    }
    
    func getTableHeightFor(_ index: Int) -> CGFloat {
        let labelWidth = (self.myTableView?.bounds.width ?? 0) - 180
        var rowHeight:CGFloat =  30
       
        if !self.dataSource[index].title.isEmpty {
            let aTitleFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
            var height = self.dataSource[index].title.sizeOfString(aTitleFont, constrainedToWidth: labelWidth).height
            
            if height < 40 {
                height = 40
            }
            
            rowHeight = rowHeight + height
        }
        
        if !self.dataSource[index].description.isEmpty {
            let aSubtitleFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
            let height = self.dataSource[index].description.sizeOfString(aSubtitleFont, constrainedToWidth: labelWidth).height
            rowHeight = rowHeight + height
        }
        
        if rowHeight < 120 {
            rowHeight = 120
        }
        
        return rowHeight
    }
    
}

//MARK:- APICallBack Methods
extension ViewController: APICallBack {
    func onData(_ info: Any?) {
        if let data =  info as? Country {
            self.country = data
            self.parseResponse(data)
            self.reloadTableData()
        }
    }
    
    func onError(_ error: String) {
        print(error)
    }
}







