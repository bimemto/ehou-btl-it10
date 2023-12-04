# Quản Lý Cửa Hàng Máy Tính

Bài tập lớn môn IT10.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed the latest version of [Node.js and npm](https://nodejs.org/en/download/).
- You have installed the latest version of [Flutter](https://flutter.dev/docs/get-started/install).
- You have a Windows/Linux/Mac machine.

## Installation 

### Back-end
Follow these steps to install the project:

1. Clone the repository:

```bash 
  git clone https://github.com/bimemto/ehou-btl-it10.git
```

2. Navigate to the project directory:
```bash 
  cd ehou-btl-it10/backend
```
3. Install the dependencies:
```bash 
  npm install
```

4. Config database connection
Open file `index.js` and config database parameters
```js
const config = {
  user: 'mssql user name',
  password: 'password',
  server: 'localhost',
  port: 1433,
  database: 'LucyStore',
  options: {
    encrypt: false,
  },
};
```

4. Running the app
To run this project, use the following command:
```bash 
  npm start
```
This will start the server at http://localhost:3002

### Front-end

1. Navigate to the project directory:
```bash 
  cd ehou-btl-it10/frontend
```
2. Install the dependencies:
```bash 
    flutter pub get
```
3. Running the app
To run this project, use the following command:
```bash 
    flutter run -d chrome
```