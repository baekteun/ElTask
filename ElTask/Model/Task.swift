import Foundation

struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time = Date()
}

struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var tasks: [Task]
    var taskDate: Date
}

func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? .init()
}

let tasks: [TaskMetaData] = [
    TaskMetaData(
        tasks: [
            Task(title: "Task to iJustine"),
            Task(title: "iPhone 14")
        ],
        taskDate: getSampleDate(offset: 1)
    ),
    TaskMetaData(
        tasks: [
            Task(title: "Meeting"),
            Task(title: "Daily"),
            Task(title: "Scrum")
        ],
        taskDate: getSampleDate(offset: -3)
    )
]
