<?php 
    include 'koneksi.php';
    
    $result= mysqli_query($koneksi, "SELECT * FROM pemasukan");
    $data= mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($data);
?>