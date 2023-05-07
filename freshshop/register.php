<?php
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

  // Get form data and insert into the database
  $fullname = $_POST["fullname"];
  $username = $_POST["username"];
  $password = $_POST["password"];
  $place = $_POST["place"];
  $mobilenumber = $_POST["mobilenumber"];
  $farmingarea = $_POST["farmingarea"];
  $sql = "INSERT INTO farmers (fullname, username, password, place, mobilenumber, farmingarea) VALUES ('$fullname', '$username', '$password', '$place', '$mobilenumber', '$farmingarea')";

  if ($conn->query($sql) === TRUE) {
    // Registration successful
    echo "Registration successful!";
  } else {
    // Registration failed
    echo "Error: " . $sql . "<br>" . $conn->error;
  }

  // Close the database connection
  $conn->close();
?>
