<?php

namespace App\Factory;

use App\Entity\Card;
use App\Repository\CardRepository;
use Zenstruck\Foundry\RepositoryProxy;
use Zenstruck\Foundry\ModelFactory;
use Zenstruck\Foundry\Proxy;

/**
 * @extends ModelFactory<Card>
 *
 * @method static Card|Proxy createOne(array $attributes = [])
 * @method static Card[]|Proxy[] createMany(int $number, array|callable $attributes = [])
 * @method static Card[]|Proxy[] createSequence(array|callable $sequence)
 * @method static Card|Proxy find(object|array|mixed $criteria)
 * @method static Card|Proxy findOrCreate(array $attributes)
 * @method static Card|Proxy first(string $sortedField = 'id')
 * @method static Card|Proxy last(string $sortedField = 'id')
 * @method static Card|Proxy random(array $attributes = [])
 * @method static Card|Proxy randomOrCreate(array $attributes = [])
 * @method static Card[]|Proxy[] all()
 * @method static Card[]|Proxy[] findBy(array $attributes)
 * @method static Card[]|Proxy[] randomSet(int $number, array $attributes = [])
 * @method static Card[]|Proxy[] randomRange(int $min, int $max, array $attributes = [])
 * @method static CardRepository|RepositoryProxy repository()
 * @method Card|Proxy create(array|callable $attributes = [])
 */
final class CardFactory extends ModelFactory
{
    public function __construct()
    {
        parent::__construct();

        // TODO inject services if required (https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#factories-as-services)
    }

    protected function getDefaults(): array
    {
        return [
            // TODO add your default values here (https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#model-factories)
            'easiness' => self::faker()->randomFloat(1, 1.3, 2.5),
            'quality' => self::faker()->numberBetween(0, 5),
            // TODO Use algorithm to calculate interval
            'interval' => self::faker()->randomNumber(),
            'repetitions' => self::faker()->randomNumber(),
            // TODO Use algorithm to calculate next_practice_date
            'next_practice_date' => self::faker()->dateTime(),
            'createdAt' => \DateTimeImmutable::createFromMutable(self::faker()->dateTime()),
        ];
    }

    protected function initialize(): self
    {
        // see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#initialization
        return $this// ->afterInstantiate(function(Card $card): void {})
            ;
    }

    protected static function getClass(): string
    {
        return Card::class;
    }
}
