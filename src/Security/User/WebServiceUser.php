<?php

namespace App\Security\User;

use phpDocumentor\Reflection\Types\This;
use Symfony\Component\Security\Core\User\EquatableInterface;
use Symfony\Component\Security\Core\User\UserInterface;

class WebServiceUser implements UserInterface, EquatableInterface
{
    private $jwt;
    private $roles;

    public function __construct($jwt, $roles)
    {
        $this->jwt = $jwt;
        $this->roles = $roles;
    }

    public function getRoles(): array
    {
        return $this->roles;
    }

    public function getPassword(): ?string
    {
        // TODO: Implement getPassword() method.
        return null;
    }

    public function getSalt(): ?string
    {
        // TODO: Implement getSalt() method.
        return null;
    }

    public function isEqualTo(UserInterface $user): bool
    {
        if(!$user instanceof WebServiceUser) {
            return false;
        }

        return $this->getUsername() === $user->getUsername();
    }

    public function getUsername()
    {
        return $this->jwt['email'] ?? $this->jwt['sub'];
    }

    public function eraseCredentials()
    {
        // TODO: Implement eraseCredentials() method.
    }

    public function getUserIdentifier(): string
    {
        return $this->jwt['email'] ?? $this->jwt['sub'];
    }
}