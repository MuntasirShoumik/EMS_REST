# Employee Management System

It is a REST API project built with Ruby on Rails.

⭐ Used <b>PostgreSQL</b> as database <br>
⭐ Used <b>JWT</b> based user authentication <br>
⭐ Used <b>Rspec</b> for writing unit tests <br>
⭐ Used <b>Sidekiq</b> for scheduling cron jobs <br>

## Installation Guide

1. Download and install Docker
2. Clone the repo

   ```bash
   https://github.com/MuntasirShoumik/EMS_REST.git
   ```

3. Open Terminal in the directory and Run

   ```bash
   docker-compose build
   ```

   ```bash
   docker compose up
   ```


4. Open another terminal and make migrations

   ```bash
   docker compose exec web rake db:migrate
   ```

## To Run the Project

Open the postman collection <b> EMS.postman_collection.json </b> in <b> Postman </b>

## Functional Requirements

### Managers

1. **Authentication:**

   - Managers should be able to register for an account. ✅
   - Managers should be able to log in using their registered credentials. ✅
   - Managers should be able to log out from the system. ✅
   - Managers should have the ability to update their passwords. ✅

2. **Employee Management:**

   - Managers should be able to create new employee records. ✅
   - Managers should be able to read and view details of existing employee who works under them. ✅
   - Managers should be able to update employee information. ✅
   - Managers should be able to remove or destroy employee records from the system. ✅

3. **Task Assignment:**

   - Managers should have the capability to assign tasks to employees, specifying task details and due dates. ✅
   - Managers should be able to view the progress and status of tasks assigned to employees. ✅

4. **Leave Management:**
   - Managers should be able to accept or reject leave requests made by employees. ✅
   - Managers should have access to a leave request history for reference. ✅

### Employees

1. **Authentication:**

   - Employees should be able to log in to their accounts using their credentials if an account is created by a manager. ✅
   - Employees should be able to log out of the system. ✅
   - Employees should be able to change their passwords. ✅

2. **Task Management:**

   - Employees should be able to view tasks assigned to them, including details such as task description and due dates. ✅
   - Employees should have the ability to update the status or progress of tasks assigned to them. ✅

3. **Leave Request:**

   - Employees should be able to submit leave requests, specifying start date, end date, and reason for leave. ✅
   - Employees should have access to the status of their leave requests, indicating whether they are approved or rejected. ✅

4. **Leave Balances:**
   - Employees should be able to view their remaining leave balances. ✅
