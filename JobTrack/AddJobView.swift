//
//  AddJobView.swift
//  JobTrack
//
//  Created by Nathan Kee on 2023-07-08.
//

import Foundation
import SwiftUI

struct AddJobView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var completionHandler: (String, String, Double, Date, String?, JobApplicationStatus) -> Void
    
    @State private var title = ""
    @State private var companyName = ""
    @State private var salaryStr = ""
    @State private var applicationDate = Date()
    @State private var notes: String? = nil
    @State private var status = JobApplicationStatus.applied
    
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
                TextField("Job Title", text: $title)
                TextField("Company Name", text: $companyName)
                HStack {
                    TextField("Salary", text: $salaryStr)
                        .keyboardType(.decimalPad)
                    if !isSalaryValid {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .accessibilityLabel("Invalid salary format")
                    }
                }
                DatePicker("Application Date", selection: $applicationDate, displayedComponents: .date)
                
                Section(header: Text("Notes")) {
                    TextField("Notes (optional)", text: Binding<String>(get: { notes ?? "" }, set: { notes = $0 }))
                }
                
                Section(header: Text("Status")) {
                    Picker("Status", selection: $status) {
                        ForEach(JobApplicationStatus.allCases, id: \.self) { jobStatus in
                            Text(jobStatus.rawValue).tag(jobStatus)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Add Job Application", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let salary = salary {
                    completionHandler(title, companyName, salary, applicationDate, notes, status)
                    presentationMode.wrappedValue.dismiss()
                }
            }.disabled(isSaveButtonDisabled))
        }
    }
}
