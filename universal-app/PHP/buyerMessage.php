<?php 

    // VARIABLES TO SEND A REPLY
    $name = $_GET['name'];
    $fromEmail = $_GET['fromEmail'];
    $receiverEmail = $_GET['receiverEmail'];
    $messageBody = $_GET['messageBody'];
    $storeName = $_GET['storeName'];
    $shippingAddress = $_GET['shippingAddress'];
    

    // SUBJECT OF THE BOOKING EMAIL
    $subject = "Your order on " .$storeName. "";


    // COMPOSE MESSAGE 
    $message = 
    "\n\n" . $messageBody .
    "\n\nYour shipping address: " . $shippingAddress .
    "\n\nThanks for buying on our store!\nFeel free to contact us for any questions/feedback at " . $fromEmail .
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
