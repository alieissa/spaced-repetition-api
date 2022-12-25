<?php

namespace App\Security\User;

use Auth0\JWTAuthBundle\Security\Core\JWTUserProviderInterface;
use stdClass;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Polyfill\Intl\Icu\Exception\NotImplementedException;

class WebServiceUserProvider implements JWTUserProviderInterface
{
    public function loadUserByJWT(stdClass $jwt): WebServiceUser
    {
        // TODO: Implement loadUserByJWT() method.
        $data = ['sub' => $jwt->sub];
        $roles = [];
        $roles[] = 'ROLE_OAUTH_AUTHENTICATED';

        return new WebServiceUser($data, $roles);
    }

    public function getAnonymousUser()
    {
        // TODO: Implement getAnonymousUser() method.
        throw new NotImplementedException('method not implemented');
    }

    public function loadUserByUsername(string $username)
    {
        // TODO: Implement loadUserByUsername() method.
        throw new NotImplementedException('method not implemented');
    }

    public function refreshUser(UserInterface $user)
    {
        if(!$user instanceof WebServiceUser) {
            throw new UnsupportedUserException(
                sprintf('Instances of "%s" are not supported', get_class($user))
            );
        }

        return $this->loadUserByUsername($user->getUsername());
    }

    public function supportsClass(string $class): bool
    {
        return $class === 'App\Security\user\WebServiceUser';
    }

    public function loadUserByIdentifier(string $identifier): UserInterface
    {
        throw new NotImplentedException('method not implemented');
    }
}