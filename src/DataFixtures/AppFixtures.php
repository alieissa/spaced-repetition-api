<?php

namespace App\DataFixtures;

use App\Answer\AnswerFactory;
use App\Card\CardFactory;
use App\Deck\DeckFactory;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $decks = DeckFactory::new()->createMany(5);

        $cards = CardFactory::new()->createMany(5, function () use ($decks) {
            return ['deck' => $decks[array_rand($decks)]];
        });

        AnswerFactory::new()->createMany(6, function (int $i) use ($cards) {
            return ["card" => $cards[$i % 2]];
        });
    }
}
