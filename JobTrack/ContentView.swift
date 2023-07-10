//
//  ContentView.swift
//  JobTrack
//
//  Created by Nathan Kee on 2023-07-08.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var jobApplications: [JobApplication] = []
    @State private var showAddJobView = false
    @State private var showArchiveView = false

    @State private var selectedJob: JobApplication? // Add this state property
    
    private var archivedJobs: [JobApplication] {
        jobApplications.filter { $0.status == .rejected }
    }

    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    func getSalaryColor(salary: Double) -> Color {
        if salary < 50_000 {
            return .red
        } else if salary >= 50_000 && salary <= 80_000 {
            return .yellow
        } else {
            return .green
        }
    }

    // Implement the `updateJob` function to handle updating the job data
    private func updateJob(_ job: JobApplication, title: String, companyName: String, salary: Double, applicationDate: Date, notes: String?, status: JobApplicationStatus) {
        // Find the index of the job to update
        if let index = jobApplications.firstIndex(where: { $0.id == job.id }) {
            // Update the job application at the found index
            jobApplications[index].title = title
            jobApplications[index].companyName = companyName
            jobApplications[index].salary = salary
            jobApplications[index].applicationDate = applicationDate
            jobApplications[index].notes = notes
            jobApplications[index].status = status
        }
    }
    
    private func deleteJob(at offsets: IndexSet) {
        jobApplications.remove(atOffsets: offsets)
    }
    
    private func statusColor(for status: JobApplicationStatus) -> Color {
        switch status {
        case .rejected:
            return .black
        case .applied:
            return .blue
        case .offer:
            return .green
        case .interview:
            return .red
        }
    }

    
    var body: some View {
            ZStack {
                NavigationView {
                    List {
                        ForEach(jobApplications.filter { $0.status != .rejected }) { jobApplication in
                            Button(action: {
                                selectedJob = jobApplication
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(jobApplication.title)
                                            .font(.headline)
                                        Text(jobApplication.companyName)
                                            .font(.subheadline)
                                        Text("Salary: $\(numberFormatter.string(from: NSNumber(value: jobApplication.salary)) ?? "")")
                                            .font(.footnote)
                                            .foregroundColor(getSalaryColor(salary: jobApplication.salary))
                                        Text(dateFormatter.string(from: jobApplication.applicationDate))
                                            .font(.footnote)
                                        Text(jobApplication.status.rawValue)
                                            .font(.footnote)
                                            .foregroundColor(statusColor(for: jobApplication.status))
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: deleteJob)
                    }
                    .navigationTitle("Job Tracker")
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddJobView = true
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.blue)
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
            }
            .sheet(isPresented: $showAddJobView) {
                AddJobView { title, companyName, salary, applicationDate, notes, status in
                    let newJob = JobApplication(title: title, companyName: companyName, salary: salary, applicationDate: applicationDate, notes: notes, status: status)
                    jobApplications.append(newJob)
                    showAddJobView = false
                }
            }
            .sheet(item: $selectedJob) { job in
                EditJobView(job: job) { updatedJob, title, companyName, salary, applicationDate, notes, status in
                    updateJob(updatedJob, title: title, companyName: companyName, salary: salary, applicationDate: applicationDate, notes: notes, status: status)
                }
            }
        }
    }



struct JobApplication: Identifiable {
    var id = UUID()
    var title: String
    var companyName: String
    var salary: Double
    var applicationDate: Date
    var notes: String?
    var status: JobApplicationStatus
}

enum JobApplicationStatus: String, CaseIterable {
    case applied = "Applied"
    case interview = "Interview"
    case offer = "Offer"
    case rejected = "Rejected"
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
