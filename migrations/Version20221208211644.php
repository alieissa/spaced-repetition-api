<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20221208211644 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP SEQUENCE question_id_seq CASCADE');
        $this->addSql('CREATE TABLE answer (id INT NOT NULL, card_id INT NOT NULL, content VARCHAR(255) NOT NULL, note TEXT DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_DADD4A254ACC9A20 ON answer (card_id)');
        $this->addSql('CREATE TABLE card (id INT NOT NULL, deck_id INT NOT NULL, easiness DOUBLE PRECISION NOT NULL, quality INT NOT NULL, interval INT NOT NULL, repetitions INT NOT NULL, next_practice_date DATE NOT NULL, created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, question TEXT NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_161498D3111948DC ON card (deck_id)');
        $this->addSql('COMMENT ON COLUMN card.created_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('COMMENT ON COLUMN card.updated_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('CREATE TABLE deck (id INT NOT NULL, name VARCHAR(255) NOT NULL, created_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, updated_at TIMESTAMP(0) WITHOUT TIME ZONE DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('COMMENT ON COLUMN deck.created_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('COMMENT ON COLUMN deck.updated_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('ALTER TABLE answer ADD CONSTRAINT FK_DADD4A254ACC9A20 FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE card ADD CONSTRAINT FK_161498D3111948DC FOREIGN KEY (deck_id) REFERENCES deck (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('CREATE SEQUENCE question_id_seq INCREMENT BY 1 MINVALUE 1 START 1');
        $this->addSql('ALTER TABLE answer DROP CONSTRAINT FK_DADD4A254ACC9A20');
        $this->addSql('ALTER TABLE card DROP CONSTRAINT FK_161498D3111948DC');
        $this->addSql('DROP TABLE answer');
        $this->addSql('DROP TABLE card');
        $this->addSql('DROP TABLE deck');
    }
}
