<?php

namespace App\Service;

use App\AutoMapping;
use App\Entity\SubscriptionEntity;
use App\Manager\SubscriptionManager;
use App\Request\SubscriptionCreateRequest;
use App\Response\SubscriptionResponse;

class SubscriptionService
{
    private $autoMapping;
    private $subscriptionManager;

    public function __construct(AutoMapping $autoMapping, SubscriptionManager $subscriptionManager)
    {
        $this->autoMapping = $autoMapping;
        $this->subscriptionManager = $subscriptionManager;
    }

    public function create(SubscriptionCreateRequest $request)
    {
        $subscriptionResult = $this->subscriptionManager->create($request);

        return $this->autoMapping->map(SubscriptionEntity::class, SubscriptionResponse::class, $subscriptionResult);
    }

    public function getCurrentSubscriptions($userId)
    {
        return $this->subscriptionManager->getCurrentSubscriptions($userId);
    }

    public function update($request)
    {
        $result = $this->subscriptionManager->update($request);

        return $this->autoMapping->map(SubscriptionEntity::class, SubscriptionResponse::class, $result);
    }
}
