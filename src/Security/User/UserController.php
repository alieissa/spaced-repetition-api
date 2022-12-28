<?php

namespace App\Security\User;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;

class UserController extends AbstractController
{
//    /**
//     * @Route("/login")
//     */
    public function index(): Response
    {
        dd("login controller");
        return new Response(Response::HTTP_OK);
    }
}
