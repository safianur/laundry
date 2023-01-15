<?php
    include 'koneksi.php';

    $tanggal = date('y-m-d');
    $nm_customer = $_POST['nm_customer'];
    $mcm_laundry = $_POST['mcm_laundry'];
    $jumlah = $_POST['jumlah'];
    $total = $_POST['total'];
    $result = mysqli_query($koneksi, "INSERT INTO pemasukan SET tanggal='$tanggal', nm_customer='$nm_customer',
                            mcm_laundry='$mcm_laundry', jumlah='$jumlah', total='$total'");
    if($result){
        echo json_encode([
            'message' => 'Input Data Pemasukan Successfully'
        ]);
    }else{
        echo json_encode([
            'message' => 'Data Failed to input'
        ]);
    }
?>