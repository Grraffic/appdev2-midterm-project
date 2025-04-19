VIDEO RECORDING
https://drive.google.com/drive/folders/1CawcqaTu55Bg06l2WfQEoXDA4rAm4e8D?usp=sharing

Building a CRUD HTTP Server Using the File System Module
Objective: Create a RESTful API that mimics JSONPlaceholder's todos endpoint using Node.js and the fs module for storing and retrieving data. Additionally, implement logging functionality to track API actions.

Instructions:
Project Setup
Create a public GitHub repository named appdev2-midterm-project.
Inside your project, create a new file named server.js.
Store your data in a JSON file (todos.json) instead of a database.
[
{ "id": 1, "title": "Learn Node.js", "completed": false },
{ "id": 2, "title": "Build an API", "completed": true }
]

Implement a logging system that writes API request logs to a logs.txt file.

Create an HTTP Server
Use the http module to create a server that listens on port 3000.
The server should handle CRUD operations similar to jsonplaceholder.typicode.com/todos.
Implement request logging using the events module.

Implement the Following Endpoints

Method
Endpoint
Description
GET
/todos
Fetch all todos (optional filtering by completed status)
GET
/todos/:id
Fetch a specific todo by ID
POST
/todos
Create a new todo
PUT
/todos/:id
Update a todo by ID
DELETE
/todos/:id
Delete a todo by ID

Handle Request Data
Use fs.readFile() and fs.writeFile() to read and update todos.json.
For POST and PUT requests:
Parse incoming JSON data from the request body.
Ensure that every new todo has a unique ID and a title.
Default the completed field to false if not provided.

Implement Logging
Use the events module to log API actions.
Log messages should include timestamps and details about API requests.
Log file: logs.txt (e.g., 2025-03-29T12:34:56.789Z - POST /todos).

Error Handling
Your API should return appropriate status codes:
✅ 200 – Success
❌ 400 – Bad request (e.g., missing fields, invalid data)
❌ 404 – Not found (e.g., trying to fetch a non-existent todo)
❌ 500 – Internal server error (e.g., failed file operations)

Submission
Upload the project to GitHub (appdev2-midterm-project repository).
Include a README.md with your profile, project summary and instructions on how to install and run your project.
Create a short video demonstration of your API and include the video link in your README.md file.
Project deadline is until April 19.
