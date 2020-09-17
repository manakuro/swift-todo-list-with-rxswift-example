//
//  AddTaskViewController.swift
//  GoodList
//
//  Copyright © 2020 manato. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
  private let taskSubject = PublishSubject<Task>()
  
  var taskSubjectObservable: Observable<Task> {
    taskSubject.asObservable()
  }
  
  @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
  @IBOutlet weak var taskTitleTextField: UITextField!
  
  @IBAction func save() {
    guard
      let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
      let title = self.taskTitleTextField.text else {
        return
    }
    
    let task = Task(title: title, priority: priority)
    
    taskSubject.onNext(task)
    
    self.dismiss(animated: true)
  }
}
