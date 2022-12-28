<?php

namespace App\Security;

use App\Security\User\UserEntity;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Exception\AuthenticationException;
use Symfony\Component\Security\Http\Authenticator\AbstractAuthenticator;
use Symfony\Component\Security\Http\Authenticator\Passport\Badge\UserBadge;
use Symfony\Component\Security\Http\Authenticator\Passport\Credentials\CustomCredentials;
use Symfony\Component\Security\Http\Authenticator\Passport\Credentials\PasswordCredentials;
use Symfony\Component\Security\Http\Authenticator\Passport\Passport;

class ApiAuthenticator extends AbstractAuthenticator
{
    public function supports(Request $request): ?bool
    {
        // TODO: Implement supports() method.
        return $request->isMethod("POST")
            && $request->getPathInfo() == "/login";
    }

    public function authenticate(Request $request): Passport
    {
        $data = $request->toArray();
        $email = $data['email'];
        $password = $data['password'];
        $userBadge = new UserBadge($email);
        $credentials = new PasswordCredentials($password);
        return new Passport(
            new UserBadge($email),
            new CustomCredentials(function ($credentials, UserEntity $user) {
                return $credentials === 'tada';
            }, $password)
        );
//        return new Passport($userBadge, $credentials);
    }

    public function onAuthenticationSuccess(Request $request,
        TokenInterface $token, string $firewallName
    ): ?Response {
        // TODO: Implement onAuthenticationSuccess() method.
        return new Response($token);
    }

    public function onAuthenticationFailure(Request $request,
        AuthenticationException $exception
    ): ?Response {
        // TODO: Implement onAuthenticationFailure() method.
        dd('failure', $exception);
    }

//    public function start(Request $request, AuthenticationException $authException = null): Response
//    {
//        /*
//         * If you would like this class to control what happens when an anonymous user accesses a
//         * protected page (e.g. redirect to /login), uncomment this method and make this class
//         * implement Symfony\Component\Security\Http\EntryPoint\AuthenticationEntryPointInterface.
//         *
//         * For more details, see https://symfony.com/doc/current/security/experimental_authenticators.html#configuring-the-authentication-entry-point
//         */
//    }
}
