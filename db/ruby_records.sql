DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS stores;

CREATE TABLE artists (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE genres (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE albums (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  artist_id INT REFERENCES artists(id),
  genre_id INT REFERENCES genres(id),
  artwork TEXT,
  sold INT,
  current_stock INT,
  target_stock INT,
  buy_price INT,
  sell_price INT
);

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  review TEXT,
  rating INT,
  album_id INT REFERENCES albums(id)
);

CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  location VARCHAR(255),
  cash INT
);
