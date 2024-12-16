<?php
include '../connection.php';

//post =send some data or sava/send data to mysql db
//get=getting some data from db or retrieve/read from mysql db

 $userEmail= $_POST['user_email'];
 $userPassword= md5($_POST['user_password']);

$sqlQuery = "SELECT * FROM users_table WHERE user_email = '$userEmail' AND user_password = '$userPassword'";

 $resultOfQuery= $connectNow->query($sqlQuery);

 if($resultOfQuery->num_rows>0){ //ALLOW  user to login

    $userRecord=array();
    while($rowFound = $resultOfQuery->fetch_assoc()){
        $userRecord[]=$rowFound;

    }
    echo json_encode(
        array(
            "success"=>true,
            "userData"=>$userRecord[0],  //this is complete row of a user that found in db
        )
    );
 }
 else{//do not allow user to login
    echo json_encode(array("success"=>false));
 }