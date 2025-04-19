VIDEO RECORDING
https://drive.google.com/drive/folders/1CawcqaTu55Bg06l2WfQEoXDA4rAm4e8D?usp=sharing

Building a CRUD HTTP Server Using the File System Module
Objective: Create a RESTful API that mimics JSONPlaceholder's todos endpoint using Node.js and the fs module for storing and retrieving data. Additionally, implement logging functionality to track API actions.

## Features

- **CRUD Operations**: Create, read, update, and delete todo items
- **Data Persistence**: Stores todo items in a JSON file
- **Filtering**: Filter todos by completion status
- **Request Logging**: Logs all API requests with timestamps
- **Error Handling**: Returns appropriate HTTP status codes for different scenarios

## Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /todos | Fetch all todos (optional filtering by completed status) |
| GET | /todos/:id | Fetch a specific todo by ID |
| POST | /todos | Create a new todo |
| PUT | /todos/:id | Update a todo by ID |
| DELETE | /todos/:id | Delete a todo by ID |

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/Grraffic/appdev2-midterm-project.git
   cd appdev2-midterm-project
   ```

2. Make sure you have Node.js installed on your system.

3. Create the initial todos.json file with sample data:
   ```json
   [
     { "id": 1, "title": "Learn Node.js", "completed": false },
     { "id": 2, "title": "Build an API", "completed": true }
   ]
   ```

## Usage

1. Start the server:
   ```
   node server.js
   ```

2. The server will run on port 3000. You can access the API at http://localhost:3000

3. Use tools like Postman, Thunder Client, or any HTTP client to interact with the API.

<div align="center">
  <img src="https://skillicons.dev/icons?i=postman" alt="Postman" height="40" />
</div>

### Example Requests

#### Get all todos
```
GET http://localhost:3000/todos
```

#### Get completed todos only
```
GET http://localhost:3000/todos?completed=true
```

#### Get a specific todo
```
GET http://localhost:3000/todos?id=1
```

#### Create a new todo
```
POST http://localhost:3000/todos
Content-Type: application/json

{
  "title": "Complete midterm project",
  "completed": false
}
```

#### Update a todo
```
PUT http://localhost:3000/todos?id=1
Content-Type: application/json

{
  "title": "Learn Node.js and Express",
  "completed": true
}
```

#### Delete a todo
```
DELETE http://localhost:3000/todos?id=1
```

## Project Structure

- `server.js` - Main application file containing the HTTP server and API logic
- `todos.json` - JSON file for storing todo items
- `logs.txt` - Log file containing API request logs
