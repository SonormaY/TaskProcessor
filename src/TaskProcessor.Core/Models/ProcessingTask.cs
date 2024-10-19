namespace TaskProcessor.Core.Models;

public class ProcessingTask
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public TaskStatus Status { get; set; }
    public int Progress { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? CompletedAt { get; set; }
    public string UserId { get; set; } = string.Empty;
    public string? ResultData { get; set; }
}

public enum TaskStatus
{
    Pending,
    Processing,
    Completed,
    Failed,
    Cancelled
}