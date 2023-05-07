<?php
  // Start a session
  session_start();

  // Connect to the database
  $servername = "localhost";
  $username = "username";
  $password = "password";
  $dbname = "database_name";
  $conn = new mysqli($servername, $username, $password, $dbname);

  // Check connection
  if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
  }

  // Get form data and check if the user exists in the database
  $username = $_POST["username"];
  $password = $_POST["password"];
  ?>