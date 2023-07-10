//
//  ArchiveView.swift
//  JobTrack
//
//  Created by Nathan Kee on 2023-07-10.
//

import Foundation
import SwiftUI

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


struct ArchiveView: View {
    let archivedJobs: [JobApplication]
    @State private var selectedJob: JobApplication?
    
    var body: some View {
        NavigationView {
            List(archivedJobs) { jobApplication in
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
            }
            .navigationTitle("Archived Jobs")
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(archivedJobs: [])
    }
}
