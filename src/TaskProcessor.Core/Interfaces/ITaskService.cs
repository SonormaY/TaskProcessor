using TaskProcessor.Core.Models;

namespace TaskProcessor.Core.Interfaces;

public interface ITaskService
{
    Task<ProcessingTask> CreateTaskAsync(ProcessingTask task);
    Task<ProcessingTask?> GetTaskAsync(int id);
    Task<IEnumerable<ProcessingTask>> GetUserTasksAsync(string userId);
    Task UpdateProgressAsync(int taskId, int progress);
    Task<bool> CancelTaskAsync(int taskId);
}