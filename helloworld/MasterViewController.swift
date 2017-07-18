//
//  MasterViewController.swift
//  helloworld
//
//  Created by iOS Dev Log on 2017/7/18.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var languages = [[String]]()
    var titles: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    func initData() {
        let resourcePath = Bundle.main.resourcePath?.appending("/hello-world/")
        
        do {
            titles = try FileManager.default.contentsOfDirectory(atPath: resourcePath!)
            
            for title in titles {
                let subResourcePath = resourcePath?.appending(title)
                let language = try FileManager.default.contentsOfDirectory(atPath: subResourcePath!)
                languages.append(language)
            }
        } catch let e {
            print(e)
        }
    }
    
    @IBAction func pickTheme(_ sender: UIBarButtonItem) {
        let themes = HighlightModel.sharedInstance.highlightr.availableThemes()
        let indexOrNil = themes.index(of: (self.title?.lowercased())!)
        let index = (indexOrNil == nil) ? 0 : indexOrNil!
        
        ActionSheetStringPicker.show(withTitle: "Pick a Theme",
                                     rows: themes,
                                     initialSelection: index,
                                     doneBlock:
            {
                picker, index, value in
                let theme = value! as! String
                HighlightModel.sharedInstance.textStorage.highlightr.setTheme(to: theme)
                self.title = theme.capitalized
                self.updateColors()
        },
                                     cancel: nil,
                                     origin: sender)
        
    }
    
    func updateColors() {
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = HighlightModel.sharedInstance.highlightr.theme.themeBackgroundColor
        navBar.tintColor = HighlightModel.sharedInstance.invertColor((navBar.barTintColor!))
        self.tableView.backgroundColor = navBar.tintColor.withAlphaComponent(0.5)
        self.tableView.reloadData()
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let language = titles[indexPath.section]
                let helloworld = languages[indexPath.section][indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                let resourcePath = Bundle.main.resourcePath?.appending("/hello-world/").appending("\(language)/\(helloworld)")
                controller.detailItem = resourcePath
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let language = languages[section]
        return language.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let language = languages[indexPath.section]
        let helloworld = language[indexPath.row]
        let names = helloworld.components(separatedBy: ".")
        cell.textLabel!.text = names[0]
        if (names.count > 1) {
            cell.detailTextLabel?.text = names[1]
        }
        cell.textLabel?.textColor = self.navigationController!.navigationBar.tintColor
        cell.detailTextLabel?.textColor = cell.textLabel?.textColor.withAlphaComponent(0.8)
        cell.backgroundColor = self.navigationController?.navigationBar.barTintColor
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
}

