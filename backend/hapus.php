<?php
    include 'koneksi.php';

    $id_pemasukan = $_POST['id_pemasukan'];
    $result = mysqli_query($koneksi, "DELETE FROM pemasukan WHERE id_pemasukan=".$id_pemasukan);
    if($result){
        echo json_encode([
            'message' => 'Succes'
        ]);
    }else{
        echo json_encode([
            'message' => 'Gagal'
        ]);
    }
?>