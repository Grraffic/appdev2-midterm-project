const http = require("http");
const fs = require("fs");
const EventEmitter = require("events");
const url = require("url");

const date = new Date();
const dateString = date.toISOString();
const todosFile = "todos.json";

const event = new EventEmitter();

event.on("log", (message) => {
  fs.appendFile("logs.txt", `${dateString}, ${message}\n`, (err) => {
    if (err) {
      console.error("Error writing to file:", err);
    }
    console.log(`${dateString} ${message}`);
  });
});

const readBody = (req, callback) => {
  let body = "";
  req.on("data", (chunk) => {
    body += chunk;
  });
  req.on("end", () => {
    try {
      const data = JSON.parse(body);
      callback(null, data);
    } catch (err) {
      callback(err);
    }
  });
};

const getTodos = (callback) => {
  fs.readFile(todosFile, "utf8", (err, data) => {
    if (err) return callback([]);
    callback(JSON.parse(data));
  });
};

const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;

  if (pathname === "/todos" && req.method === "GET") {
    const todoId = parsedUrl.query.id;
    getTodos((todos) => {
      if (todoId) {
        const todo = todos.find((item) => item.id == todoId);
        if (todo) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(todo));
          event.emit("log", `Fetch todo with id=${todoId}`);
        } else {
          res.writeHead(404, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ message: "Todo not found" }));
          event.emit("log", `Todo id=${todoId} not found`);
        }
      } else {
        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify(todos));
        event.emit("log", "Fetched all todos");
      }
    });
  } else if (pathname === "/todos" && req.method === "POST") {
    readBody(req, (err, newTodo) => {
      if (err) {
        res.writeHead(400, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Invalid JSON" }));
        event.emit("log", "Received invalid JSON");
        return;
      }

      getTodos((todos) => {
        if (newTodo.id && todos.some((t) => t.id == newTodo.id)) {
          res.writeHead(400, { "Content-Type": "application/json" });
          res.end(
            JSON.stringify({
              message: `Todo with id=${newTodo.id} already exists`,
            })
          );
          event.emit("log", `Attempted to add duplicate todo id=${newTodo.id}`);
          return;
        }

        if (!newTodo.id) {
          newTodo.id =
            todos.length > 0 ? Math.max(...todos.map((t) => t.id)) + 1 : 1;
        }

        todos.push(newTodo);

        fs.writeFile(todosFile, JSON.stringify(todos, null, 2), (err) => {
          if (err) {
            res.writeHead(500, { "Content-Type": "application/json" });
            res.end(JSON.stringify({ message: "Failed to save todo" }));
            event.emit("log", "Error saving new todo");
            return;
          }

          res.writeHead(201, { "Content-Type": "application/json" });
          res.end(JSON.stringify(newTodo));
          event.emit("log", `Added new todo with id=${newTodo.id}`);
        });
      });
    });
  } else if (pathname === "/todos" && req.method === "PUT") {
    const todoId = parsedUrl.query.id;

    if (!todoId) {
      res.writeHead(400, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ message: "Missing todo id in query" }));
      event.emit("log", "PUT request missing id");
      return;
    }

    readBody(req, (err, updatedTodoData) => {
      if (err) {
        res.writeHead(400, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Invalid JSON" }));
        event.emit("log", "Invalid JSON in PUT request");
        return;
      }

      getTodos((todos) => {
        const index = todos.findIndex((item) => item.id == todoId);
        if (index === -1) {
          res.writeHead(404, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ message: "Todo not found" }));
          event.emit("log", `Failed PUT: Todo id=${todoId} not found`);
          return;
        }

        todos[index] = {
          ...todos[index],
          ...updatedTodoData,
          id: todos[index].id,
        };

        fs.writeFile(todosFile, JSON.stringify(todos, null, 2), (err) => {
          if (err) {
            res.writeHead(500, { "Content-Type": "application/json" });
            res.end(JSON.stringify({ message: "Failed to update todo" }));
            event.emit("log", `Error updating todo id=${todoId}`);
            return;
          }

          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(todos[index]));
          event.emit("log", `Updated todo id=${todoId}`);
        });
      });
    });
  } else if (pathname === "/todos" && req.method === "DELETE") {
    const todoId = parsedUrl.query.id;

    if (!todoId) {
      res.writeHead(400, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ message: "Missing todo id in query" }));
      event.emit("log", "DELETE request missing id");
      return;
    }

    getTodos((todos) => {
      const index = todos.findIndex((item) => item.id == todoId);
      if (index === -1) {
        res.writeHead(404, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ message: "Todo not found" }));
        event.emit("log", `Failed DELETE: Todo id=${todoId} not found`);
        return;
      }

      const deleted = todos.splice(index, 1)[0];

      fs.writeFile(todosFile, JSON.stringify(todos, null, 2), (err) => {
        if (err) {
          res.writeHead(500, { "Content-Type": "application/json" });
          res.end(JSON.stringify({ message: "Failed to delete todo" }));
          event.emit("log", `Error deleting todo id=${todoId}`);
          return;
        }

        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify(deleted));
        event.emit("log", `Deleted todo id=${todoId}`);
      });
    });
  } else {
    res.writeHead(404, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ message: "Route not found" }));
    event.emit("log", `404 Not Found: ${req.method} ${pathname}`);
  }
});

const port = 3000;
const host = "localhost";

server.listen(port, host, () => {
  console.log(`Server is running on http://${host}:${port}`);
  event.emit("log", `Server started on http://${host}:${port}`);
});
