<?php

namespace App\Card;

use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

class CardController extends AbstractController
{
    private CardRepository $cardRepository;
    private LoggerInterface $logger;
    private SerializerInterface $serlializer;

    public function __construct(CardRepository $cardRepository, SerializerInterface $serlializer, LoggerInterface $logger)
    {
        $this->cardRepository = $cardRepository;
        $this->logger = $logger;
        $this->serlializer = $serlializer;
    }

    /**
     * @Route("/card", name="app_card_card", methods={"GET"})
     */
    public function index(): Response
    {
        $data = $this->cardRepository->findAll();
        return $this->json($data);
    }
}
