<?php

$host = "localhost";
$db   = "library_db";
$user = "postgres";
$pass = "password";
$port = 5432;

$connectionString = "Driver={PostgreSQL Unicode};Server=$host;Port=$port;Database=$db;Uid=$user;Pwd=$pass;";

echo "<h1>Library Management System (PHP + ODBC)</h1>";

try {
    $conn = odbc_connect($connectionString, $user, $pass);

    if (!$conn) {
        throw new Exception("ODBC Connection Failed: " . odbc_errormsg());
    }

    echo "<p style='color: green;'>Successfully connected to PostgreSQL via ODBC!</p>";

    echo "<h2>Current Book Inventory (SQL Joins)</h2>";
    $query = "SELECT b.title, a.name AS author_name, b.available_copies 
              FROM books b 
              INNER JOIN authors a ON b.author_id = a.author_id";
    
    $result = odbc_exec($conn, $query);

    echo "<table border='1' cellpadding='10'>";
    echo "<tr><th>Title</th><th>Author</th><th>Available Copies</th></tr>";
    while ($row = odbc_fetch_array($result)) {
        echo "<tr>";
        echo "<td>" . $row['title'] . "</td>";
        echo "<td>" . $row['author_name'] . "</td>";
        echo "<td>" . $row['available_copies'] . "</td>";
        echo "</tr>";
    }
    echo "</table>";

    echo "<h2>Late Fee Calculation (SQL Functions)</h2>";
    $loanDate = '2023-10-01';
    $returnDate = '2023-10-20';
    
    $funcQuery = "SELECT calculate_late_fee('$loanDate', '$returnDate') AS fine";
    $funcResult = odbc_exec($conn, $funcQuery);
    $fineRow = odbc_fetch_array($funcResult);

    echo "<p>Loan Date: $loanDate</p>";
    echo "<p>Return Date: $returnDate</p>";
    echo "<p><strong>Calculated Fine: $" . number_format($fineRow['fine'], 2) . "</strong></p>";

    odbc_close($conn);

} catch (Exception $e) {
    echo "<p style='color: red;'>Error: " . $e->getMessage() . "</p>";
    echo "<p><em>Note: Ensure PostgreSQL ODBC driver is installed and the connection details are correct.</em></p>";
}
?>

<style>
    body { font-family: sans-serif; line-height: 1.6; max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
    table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
    th { background-color: #f4f4f4; text-align: left; }
    h1 { color: #2c3e50; border-bottom: 2px solid #2c3e50; padding-bottom: 0.5rem; }
</style>
