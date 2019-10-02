<?php 

    // VARIABLES TO SEND A REPLY
    $name = $_GET['name'];
    $fromEmail = $_GET['fromEmail'];
    $receiverEmail = $_GET['receiverEmail'];
    $messageBody = $_GET['messageBody'];
    $storeName = $_GET['storeName'];
    $shippingAddress = $_GET['shippingAddress'];


    // SUBJECT OF THE BOOKING EMAIL
    $subject = "Order from " .$name. " on " .$storeName. "";

    // COMPOSE MESSAGE 
    $message = "Username: " . $name . 
    "\nUser Email: " . $fromEmail .
    "\n\n" . $messageBody .
    "\n\nTo be shipped to: " . $shippingAddress .
    ""
    ;

    /* Finally send email */
    mail($receiverEmail,
        $subject, 
        $message
        );

/* Result */
    echo "Email Sent";
?>
