<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20221227230042 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE answer DROP CONSTRAINT FK_DADD4A254ACC9A20');
        $this->addSql('ALTER TABLE answer ADD CONSTRAINT FK_DADD4A254ACC9A20 FOREIGN KEY (card_id) REFERENCES card (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE card ALTER created_at SET DEFAULT CURRENT_TIMESTAMP');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE answer DROP CONSTRAINT fk_dadd4a254acc9a20');
        $this->addSql('ALTER TABLE answer ADD CONSTRAINT fk_dadd4a254acc9a20 FOREIGN KEY (card_id) REFERENCES card (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE card ALTER created_at DROP DEFAULT');
    }
}
