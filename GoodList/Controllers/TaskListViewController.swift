//
//  TaskListViewController.swift
//  GoodList
//
//  Copyright © 2020 manato. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let disponseBag = DisposeBag()
  
  private var tasks = BehaviorRelay<[Task]>(value: [])
  private var filteredTasks = [Task]()
  
  @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.filteredTasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
    
    cell.textLabel?.text = self.filteredTasks[indexPath.row].title
    
    return cell
  }
  
  @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
    let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
    
    self.filterTasks(by: priority)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let vc = segue.destination as? UINavigationController,
      let addVC = vc.viewControllers.first as? AddTaskViewController else {
        fatalError("NO VC FOUND")
    }
    
    addVC.taskSubjectObservable.subscribe(onNext: { [unowned self] task in
      let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
      
      var existingTasks = self.tasks.value
      existingTasks.append(task)
      
      self.tasks.accept(existingTasks)
      
      self.filterTasks(by: priority)
    }).disposed(by: disponseBag)
  }
  
  private func updateTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  private func filterTasks(by priority: Priority?) {
    if priority == nil {
      self.filteredTasks = self.tasks.value
      self.updateTableView()
      return;
    }
    
    self.tasks.map { t in
      t.filter { $0.priority == priority }
    }.subscribe(onNext: { [weak self] tasks in
      self?.filteredTasks = tasks
      self?.updateTableView()
    }).disposed(by: disponseBag)
  }
}
