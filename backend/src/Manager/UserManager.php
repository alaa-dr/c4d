<?php

namespace App\Manager;

use App\AutoMapping;
use App\Entity\UserEntity;
use App\Entity\UserProfileEntity;
use App\Entity\CaptainProfileEntity;
use App\Repository\UserEntityRepository;
use App\Repository\UserProfileEntityRepository;
use App\Repository\CaptainProfileEntityRepository;
use App\Request\UserProfileCreateRequest;
use App\Request\CaptainProfileCreateRequest;
use App\Request\UserProfileUpdateRequest;
use App\Request\CaptainProfileUpdateRequest;
use App\Request\UserRegisterRequest;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;

class UserManager
{
    private $autoMapping;
    private $entityManager;
    private $encoder;
    private $userRepository;
    private $userProfileEntityRepository;
    private $captainProfileEntityRepository;

    public function __construct(AutoMapping $autoMapping, EntityManagerInterface $entityManager, UserPasswordEncoderInterface $encoder, UserEntityRepository $userRepository, UserProfileEntityRepository $userProfileEntityRepository, CaptainProfileEntityRepository $captainProfileEntityRepository)
    {
        $this->autoMapping = $autoMapping;
        $this->entityManager = $entityManager;
        $this->encoder = $encoder;
        $this->userRepository = $userRepository;
        $this->userProfileEntityRepository = $userProfileEntityRepository;
        $this->captainProfileEntityRepository = $captainProfileEntityRepository;
    }

    public function userRegister(UserRegisterRequest $request)
    {
        $userRegister = $this->autoMapping->map(UserRegisterRequest::class, UserEntity::class, $request);

        $user = new UserEntity($request->getUserID());

        if ($request->getPassword()) {
            $userRegister->setPassword($this->encoder->encodePassword($user, $request->getPassword()));
        }

        if ($request->getRoles() == null) {
            $request->setRoles(['user']);
        }
        $userRegister->setRoles($request->getRoles());

        $this->entityManager->persist($userRegister);
        $this->entityManager->flush();
        $this->entityManager->clear();

        return $userRegister;
    }

    public function userProfileCreate(UserProfileCreateRequest $request)
    {
        $userProfile = $this->autoMapping->map(UserProfileCreateRequest::class, UserProfileEntity::class, $request);

        $this->entityManager->persist($userProfile);
        $this->entityManager->flush();
        $this->entityManager->clear();

        return $userProfile;
    }

    public function userProfileUpdate(UserProfileUpdateRequest $request)
    {
        $item = $this->userProfileEntityRepository->getUserProfile($request->getUserID());

        if ($item) {
            $item = $this->autoMapping->mapToObject(UserProfileUpdateRequest::class, UserProfileEntity::class, $request, $item);

            $this->entityManager->flush();
            $this->entityManager->clear();

            return $item;
        }
    }

    public function getProfileByUserID($userID)
    {
        return $this->userProfileEntityRepository->getProfileByUSerID($userID);
    }

    public function getremainingOrders($userID)
    {
        $date = new \DateTime("Now");
        return $this->userProfileEntityRepository->getremainingOrders($userID, $date);
    }

    public function captainprofileCreate(CaptainProfileCreateRequest $request)
    {
        $captainprofile = $this->autoMapping->map(CaptainProfileCreateRequest::class, CaptainProfileEntity::class, $request);

        $this->entityManager->persist($captainprofile);
        $this->entityManager->flush();
        $this->entityManager->clear();

        return $captainprofile;
    }

    public function captainprofileUpdate(CaptainProfileUpdateRequest $request)
    {
        $item = $this->captainProfileEntityRepository->getCaptainprofile($request->getCaptainID());

        if ($item) {
            $item = $this->autoMapping->mapToObject(CaptainProfileUpdateRequest::class, CaptainProfileEntity::class, $request, $item);

            $this->entityManager->flush();
            $this->entityManager->clear();

            return $item;
        }
    }

    public function getcaptainprofileByID($userID)
    {
        return $this->captainProfileEntityRepository->getCaptainprofileByUserID($userID);
    }
}
