pragma solidity ^0.8.0;

contract DTaskList {
	struct Task {
		string content;
		bool isCompleted;
		address creator;
	}

	mapping(address => Task[]) public userTasks;

	event TaskCreated(address creator, uint taskId, string content);
	event TaskCompleted(address creator, uint taskId);
	event TaskDeleted(address creator, uint taskId);
	event TaskUpdated(address indexed creator, uint256 taskId, string content);

	function createTask(string memory _content) public {
		Task memory newTask = Task({ content: _content, isCompleted: false, creator: msg.sender });
		userTasks[msg.sender].push(newTask);
		emit TaskCreated(msg.sender, userTasks[msg.sender].length - 1, _content);
	}

	function getMyTasks() public view returns (Task[] memory) {
		return userTasks[msg.sender];
	}

	function markAsDone(uint _taskId) public {
		require(_taskId < userTasks[msg.sender].length, "Invalid task ID.");
		require(!userTasks[msg.sender][_taskId].isCompleted, "Task is already completed.");
		require(userTasks[msg.sender][_taskId].creator == msg.sender, "You are not the creator of this task.");
		userTasks[msg.sender][_taskId].isCompleted = true;
		emit TaskCompleted(msg.sender, _taskId);
	}

	function deleteTask(uint _taskId) public {
		require(_taskId < userTasks[msg.sender].length, "Invalid task ID.");
		require(userTasks[msg.sender][_taskId].creator == msg.sender, "You are not the creator of this task.");

		// 为了保持简单，我们将任务内容设置为空字符串，而不是真正删除数组元素
		// 在更复杂的场景中，可能需要更复杂的数组管理逻辑
		userTasks[msg.sender][_taskId].content = "";
		emit TaskDeleted(msg.sender, _taskId);
	}

	function editTask(uint256 taskId, string memory newContent) public {
		require(taskId < userTasks[msg.sender].length, "Task ID out of bounds.");
		require(!userTasks[msg.sender][taskId].isCompleted, "Completed tasks cannot be edited.");
		require(bytes(newContent).length > 0, "Content cannot be empty.");
		userTasks[msg.sender][taskId].content = newContent;
		emit TaskUpdated(msg.sender, taskId, newContent);
	}
}
