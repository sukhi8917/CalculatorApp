<?php
include '../connection.php';

//post =send some data or sava/send data to mysql db
//get=getting some data from db or retrieve/read from mysql db

 $adminEmail= $_POST['admin_email'];
 $adminPassword= $_POST['admin_password'];

$sqlQuery = "SELECT * FROM admin_table WHERE admin_email = '$adminEmail' AND admin_password = '$adminPassword'";

 $resultOfQuery= $connectNow->query($sqlQuery);

 if($resultOfQuery->num_rows>0){ //ALLOW  admin to login

    $adminRecord=array();
    while($rowFound = $resultOfQuery->fetch_assoc()){
        $adminRecord[]=$rowFound;

    }
    echo json_encode(
        array(
            "success"=>true,
            "adminData"=>$adminRecord[0],
        )
    );
 }
 else{//do not allow admin to login
    echo json_encode(array("success"=>false));
 }