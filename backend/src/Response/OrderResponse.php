<?php

namespace App\Response;

class OrderResponse
{
    public $id;
    public $source = [];
    public $destination = [];
    public $date;
    public $updateDate;
    public $note;
    public $payment;
    public $recipientName;
    public $recipientPhone;
    public $state;
    public $acceptedOrder;
    
}
