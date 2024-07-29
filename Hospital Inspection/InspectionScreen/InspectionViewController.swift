//
//  InspectionViewController.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 27/07/24.
//

import UIKit

class InspectionViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: properties
    let inspectionViewModel = InspectionViewModel()
    
    //MARK: - life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 24
        inspectionViewModel.updateDelegate = self
        inspectionViewModel.getAndAddInspectionDataFromLocalJsonFile()
        setupTableView()
        tableView.reloadData()
    }
    
    //MARK: - Button Actions
    @IBAction func submitButtonAction(_ sender: Any) {
        inspectionViewModel.submitInspection()
    }
    
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        self.tableView.register(UINib(nibName: "SurveyQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "SurveyQuestionTableViewCell")
    }
    
}

extension InspectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return inspectionViewModel.formFieldData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < inspectionViewModel.formFieldData.count else { return .zero }
        switch inspectionViewModel.formFieldData[section] {
        case .inspectionType, .area:
            return 1
        case .survey(let category):
            return category.questions?.count ?? .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < inspectionViewModel.formFieldData.count else { return UITableViewCell() }
        switch inspectionViewModel.formFieldData[indexPath.section] {
        case .inspectionType(let name):
            let title = "Inspection Type: " + name
            return getCellWithTitle(title: title, tableView: tableView, indexPath: indexPath)
        case .area(let name):
            let title = "Area: " + name
            return getCellWithTitle(title: title, tableView: tableView, indexPath: indexPath)
        case .survey(let category):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyQuestionTableViewCell", for: indexPath) as? SurveyQuestionTableViewCell else { return UITableViewCell() }
            guard let questions = category.questions, indexPath.row < questions.count else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.tag = category.id ?? .zero
            cell.configureCell(question: questions[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < inspectionViewModel.formFieldData.count else { return .zero }
        switch inspectionViewModel.formFieldData[indexPath.section] {
        case .inspectionType, .area:
            return 40
        case .survey:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < inspectionViewModel.formFieldData.count else { return "" }
        switch inspectionViewModel.formFieldData[section] {
        case .inspectionType, .area:
            return ""
        case .survey(let category):
            return "Survey: \(category.name ?? "")"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard section < inspectionViewModel.formFieldData.count else { return }
        switch inspectionViewModel.formFieldData[section] {
        case .inspectionType, .area:
            return
        case .survey:
            if let headerView = view as? UITableViewHeaderFooterView {
                headerView.contentView.backgroundColor = .clear
                headerView.backgroundView?.backgroundColor = .clear
                headerView.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
                headerView.textLabel?.textColor = .white
            }
        }
   }
    
    
    func getCellWithTitle(title: String, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = title
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension InspectionViewController: UpdateInspectionVCProtocol {
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlertMessage(message)
        }
    }
    
}
