-- v4 Bible-first: the Bible is the flagship work, so it leads the catalogue.
-- launch_rank carries a unique constraint, so shift everything out of the way first.
UPDATE works SET launch_rank = launch_rank + 100;
UPDATE works SET launch_rank = 1 WHERE slug = 'the-bible';
UPDATE works SET launch_rank = 2 WHERE slug = 'a-tale-of-two-cities';
UPDATE works SET launch_rank = 3 WHERE slug = 'the-diary-of-a-young-girl';
UPDATE works SET launch_rank = 4 WHERE slug = 'the-alchemist';
UPDATE works SET launch_rank = 5 WHERE slug = 'the-hobbit';
