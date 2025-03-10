import SwiftUI

struct TaskManagerView: View {
    @ObservedObject var settings: PomateSettings
    @State private var newTaskName: String = ""
    @State private var showCompletedTasks: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Task input field
            HStack {
                TextField("New task...", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !newTaskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        settings.addTask(name: newTaskName)
                        newTaskName = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
                .disabled(newTaskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            // Filter toggle
            Toggle("Show completed tasks", isOn: $showCompletedTasks)
                .toggleStyle(.switch)
                .font(.caption)
            
            // Task list
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(filteredTasks) { task in
                        TaskRow(
                            task: task,
                            isCurrentTask: task.id == settings.currentTaskId,
                            onToggleCompletion: {
                                settings.toggleTaskCompletion(taskId: task.id)
                            },
                            onSetCurrent: {
                                settings.currentTaskId = task.id
                            },
                            onDelete: {
                                settings.deleteTask(taskId: task.id)
                            }
                        )
                    }
                    
                    if filteredTasks.isEmpty {
                        Text(showCompletedTasks ? "No completed tasks" : "No active tasks")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    // Filter tasks based on completion status
    var filteredTasks: [PomateSettings.Task] {
        settings.tasks.filter { task in
            showCompletedTasks ? task.isCompleted : !task.isCompleted
        }
    }
}

// Individual task row
struct TaskRow: View {
    let task: PomateSettings.Task
    let isCurrentTask: Bool
    let onToggleCompletion: () -> Void
    let onSetCurrent: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            // Completion checkbox
            Button(action: onToggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            // Task name
            Text(task.name)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .secondary : .primary)
            
            // Session count if any
            if task.associatedSessions > 0 {
                Spacer()
                Text("\(task.associatedSessions)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.secondary.opacity(0.1))
                    )
            }
            
            Spacer()
            
            // Current task indicator/selector
            Button(action: onSetCurrent) {
                Image(systemName: isCurrentTask ? "star.fill" : "star")
                    .foregroundColor(isCurrentTask ? .yellow : .gray)
            }
            .buttonStyle(.plain)
            .help(isCurrentTask ? "Current task" : "Set as current task")
            
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .help("Delete task")
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isCurrentTask ? Color.accentColor.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}
