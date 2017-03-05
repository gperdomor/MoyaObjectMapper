//
//  MoyaViewController.swift
//  Demo
//
//  Created by Gustavo Perdomo on 2/20/17.
//  Copyright (c) 2017 Gustavo Perdomo. Licensed under the MIT license, as follows:
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class MoyaViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var manager = IssueTracker()
    var repositories = [Repository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        searchBar.delegate = self
        searchBar.placeholder = "Github Username and press Search"

        tableView.delegate = self
        tableView.dataSource = self

        searchBar.text = "gperdomor"

        self.downloadRepos(from: searchBar.text!)
    }

    func downloadRepos(from username: String) {
        _ = manager.findUserRepositories(name: username, completion: { result in
            var success = true
            var message = "Unable to fetch from GitHub"

            switch result {
            case let .success(response):
                do {
                    self.repositories = try response.map(to: [Repository.self])
                } catch {
                    success = false
                    self.repositories = []
                }
                self.tableView.reloadData()
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                message = error.description
                success = false
            }

            if !success {
                let alertController = UIAlertController(title: "GitHub Fetch", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) -> Void in
                    alertController.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        downloadRepos(from: searchBar.text!)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Table View
    func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        if(searchBar.isFirstResponder) {
            searchBar.resignFirstResponder()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoyaCell", for: indexPath) as UITableViewCell

        let repo = repositories[(indexPath as NSIndexPath).row]
        (cell.textLabel as UILabel!).text = repo.name
        return cell
    }
}
