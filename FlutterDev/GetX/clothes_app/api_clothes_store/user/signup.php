<?php
include '../connection.php';

//post =send some data or sava/send data to mysql db
//get=getting some data from db or retrieve/read from mysql db

 $userName= $_POST['user_name'];
 $userEmail= $_POST['user_email'];
 $userPassword= md5($_POST['user_password']);

//''last me 
$sqlQuery = "INSERT INTO users_table SET user_name = '$userName',user_email = '$userEmail',user_password = '$userPassword'";

 $resultOfQuery= $connectNow->query($sqlQuery);

 if($resultOfQuery){
    echo json_encode(array("success"=>true));
 }
 else{
    echo json_encode(array("success"=>false));
 }