const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DTaskList", function () {
	let DTaskList;
	let dTaskList;
	let owner;
	let addr1;
	let addr2;

	beforeEach(async function () {
		[owner, addr1, addr2] = await ethers.getSigners();

		DTaskList = await ethers.getContractFactory("DTaskList");
		dTaskList = await DTaskList.deploy();
		await dTaskList.waitForDeployment();
	});

	it("Should allow creating a new task", async function () {
		await dTaskList.createTask("Buy groceries");
		const tasks = await dTaskList.getMyTasks();
		expect(tasks.length).to.equal(1);
		expect(tasks[0].content).to.equal("Buy groceries");
		expect(tasks[0].isCompleted).to.equal(false);
	});

	it("Should allow marking a task as done", async function () {
		await dTaskList.createTask("Walk the dog");
		await dTaskList.markAsDone(0);
		const tasks = await dTaskList.getMyTasks();
		expect(tasks[0].isCompleted).to.equal(true);
	});

	it("Should allow 'deleting' a task by setting content to empty and isCompleted to true", async function () {
		await dTaskList.createTask("Pay bills");
		await dTaskList.deleteTask(0);
		const tasks = await dTaskList.getMyTasks();
		expect(tasks.length).to.equal(1); // 任务数量仍然是 1
		expect(tasks[0].content).to.equal(""); // 内容应该为空
	});

	it("Should allow editing a task", async function () {
		await dTaskList.createTask("Clean the house");
		await dTaskList.editTask(0, "Do laundry");
		const tasks = await dTaskList.getMyTasks();
		expect(tasks[0].content).to.equal("Do laundry");
	});
});
