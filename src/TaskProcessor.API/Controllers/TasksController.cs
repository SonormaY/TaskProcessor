using Microsoft.AspNetCore.Mvc;
using TaskProcessor.Core.Interfaces;
using TaskProcessor.Core.Models;

namespace TaskProcessor.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TasksController : ControllerBase
{
    private readonly ITaskService _taskService;
    private readonly ILogger<TasksController> _logger;

    public TasksController(ITaskService taskService, ILogger<TasksController> logger)
    {
        _taskService = taskService;
        _logger = logger;
    }

    [HttpPost]
    public async Task<ActionResult<ProcessingTask>> CreateTask([FromBody] ProcessingTask task)
    {
        try
        {
            var createdTask = await _taskService.CreateTaskAsync(task);
            return CreatedAtAction(nameof(GetTask), new { id = createdTask.Id }, createdTask);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating task");
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ProcessingTask>> GetTask(int id)
    {
        var task = await _taskService.GetTaskAsync(id);
        if (task == null)
            return NotFound();
        return Ok(task);
    }

    [HttpPost("{id}/cancel")]
    public async Task<IActionResult> CancelTask(int id)
    {
        var result = await _taskService.CancelTaskAsync(id);
        if (!result)
            return NotFound();
        return Ok();
    }
}