//
//  EditJobView.swift
//  JobTrack
//
//  Created by Nathan Kee on 2023-07-10.
//

import Foundation
import SwiftUI

struct EditJobView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var job: JobApplication
    var updateHandler: (JobApplication, String, String, Double, Date, String?, JobApplicationStatus) -> Void
    
    @State private var title: String
    @State private var companyName: String
    @State private var salaryStr: String
    @State private var applicationDate: Date
    @State private var notes: String?
    @State private var status: JobApplicationStatus
    
    init(job: JobApplication, updateHandler: @escaping (JobApplication, String, String, Double, Date, String?, JobApplicationStatus) -> Void) {
        self.job = job
        self.updateHandler = updateHandler
        
        _title = State(initialValue: job.title)
        _companyName = State(initialValue: job.companyName)
        _salaryStr = State(initialValue: "\(job.salary)")
        _applicationDate = State(initialValue: job.applicationDate)
        _notes = State(initialValue: job.notes)
        _status = State(initialValue: job.status)
    }
    
    var salary: Double? {
        Double(salaryStr)
    }
    
    var isSaveButtonDisabled: Bool {
        title.isEmpty || companyName.isEmpty || salary == nil
    }
    
    var isSalaryValid: Bool {
        Double(salaryStr) != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Job Details")) {
                    TextField("Title", text: $title)
                    TextField("Company Name", text: $companyName)
                    TextField("Salary", text: $salaryStr)
                        .keyboardType(.decimalPad)
                    DatePicker("Application Date", selection: $applicationDate, displayedComponents: .date)
                }

                Section(header: Text("Notes")) {
                    TextField("Notes (optional)", text: Binding(
                        get: { notes ?? "" },
                        set: { notes = $0.isEmpty ? nil : $0 }
                    ))
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: $status) {
                        ForEach(JobApplicationStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Edit Job Application", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let salary = salary {
                    updateHandler(job, title, companyName, salary, applicationDate, notes, status)
                    presentationMode.wrappedValue.dismiss()
                }
            }.disabled(isSaveButtonDisabled))
        }
    }
}
