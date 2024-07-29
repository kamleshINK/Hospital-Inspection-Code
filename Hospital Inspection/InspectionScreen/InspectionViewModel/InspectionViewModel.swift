//
//  InspectionViewModel.swift
//  Hospital Inspection
//
//  Created by Kamlesh Nimradkar on 27/07/24.
//

import Foundation
protocol UpdateInspectionVCProtocol: AnyObject {
    func reloadTableView()
    func showAlert(message: String)
}

class InspectionViewModel {
    
    var inspectionData: InspectionData?
    var formFieldData = [FormFieldType]()
    
    weak var updateDelegate: UpdateInspectionVCProtocol?
    private var inspectionAPIServiceManager = InspectionAPIServiceManager()
    
    func startInspection() {
        inspectionAPIServiceManager.getInspectionDataAndStart { [weak self] result in
            switch result {
            case .success(let inspectionData):
                self?.inspectionData = inspectionData
                self?.addFormFieldData(inspectionData: inspectionData)
                self?.updateDelegate?.reloadTableView()
                
            case .failure(let error):
                self?.updateDelegate?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func submitInspection() {
        guard let inspectionData else { return }
        inspectionAPIServiceManager.submitInspectionData(inspectionData: inspectionData) { [weak self] result in
            guard let wSelf = self else { return }
            switch result {
            case .success:
                let scoreMessage = wSelf.getInspectionScore(inspectionData: inspectionData)
                wSelf.updateDelegate?.showAlert(message: scoreMessage)
                wSelf.inspectionData = nil
                wSelf.updateDelegate?.reloadTableView()
            case .failure(let error as NSError):
                var message: String
                switch error.code {
                case 500:
                    message = "Inspection Data is not complete"
                default:
                    message = error.localizedDescription
                }
                wSelf.updateDelegate?.showAlert(message: message)
            }
        }
    }
    
    func getAndAddInspectionDataFromLocalJsonFile() {
        if let path = Bundle.main.path(forResource: "inspection", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                if let jsonResult = try? JSONDecoder().decode(InspectionData.self, from: data) {
                    inspectionData = jsonResult
                    addFormFieldData(inspectionData: inspectionData)
                }
            } catch {
                print("error")
            }
        }
    }
    
    func addFormFieldData(inspectionData: InspectionData?) {
        guard let inspection = inspectionData?.inspection else { return }
        formFieldData.append(.inspectionType(inspection.inspectionType?.name ?? ""))
        formFieldData.append(.area(inspection.area?.name ?? ""))
        guard let surveyCategories = inspection.survey?.categories else { return }
        surveyCategories.forEach { category in
            formFieldData.append(.survey(category))
        }
    }
    
    func getInspectionScore(inspectionData: InspectionData) -> String {
        var score: Float = .zero
        guard let categories = inspectionData.inspection?.survey?.categories else { return "Inspection Score: \(score)" }
        categories.forEach { category in
            category.questions?.forEach({ question in
                let ansScore = question.answerChoices?.first(where: {$0.id == question.selectedAnswerChoiceId})?.score
                score += ansScore ?? .zero
            })
        }
        
        return "Inspection Score: \(score)"
    }
    
}
