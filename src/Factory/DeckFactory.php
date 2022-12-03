<?php

namespace App\Factory;

use App\Entity\Deck;
use App\Repository\DeckRepository;
use Zenstruck\Foundry\RepositoryProxy;
use Zenstruck\Foundry\ModelFactory;
use Zenstruck\Foundry\Proxy;

/**
 * @extends ModelFactory<Deck>
 *
 * @method static Deck|Proxy createOne(array $attributes = [])
 * @method static Deck[]|Proxy[] createMany(int $number, array|callable $attributes = [])
 * @method static Deck[]|Proxy[] createSequence(array|callable $sequence)
 * @method static Deck|Proxy find(object|array|mixed $criteria)
 * @method static Deck|Proxy findOrCreate(array $attributes)
 * @method static Deck|Proxy first(string $sortedField = 'id')
 * @method static Deck|Proxy last(string $sortedField = 'id')
 * @method static Deck|Proxy random(array $attributes = [])
 * @method static Deck|Proxy randomOrCreate(array $attributes = [])
 * @method static Deck[]|Proxy[] all()
 * @method static Deck[]|Proxy[] findBy(array $attributes)
 * @method static Deck[]|Proxy[] randomSet(int $number, array $attributes = [])
 * @method static Deck[]|Proxy[] randomRange(int $min, int $max, array $attributes = [])
 * @method static DeckRepository|RepositoryProxy repository()
 * @method Deck|Proxy create(array|callable $attributes = [])
 */
final class DeckFactory extends ModelFactory
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
            'name' => self::faker()->text(),
            'createdAt' => \DateTimeImmutable::createFromMutable(self::faker()->dateTime()),
        ];
    }

    protected function initialize(): self
    {
        // see https://symfony.com/bundles/ZenstruckFoundryBundle/current/index.html#initialization
        return $this
            // ->afterInstantiate(function(Deck $deck): void {})
        ;
    }

    protected static function getClass(): string
    {
        return Deck::class;
    }
}
