CREATE TABLE IF NOT EXISTS "tracks"
(
	[tid] integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	[longitude] real,
	[latitude] real,
    [trackGroup] text,
	[trackName] text,
	[trackAddress] text,
	[trackType] integer,
	[trackTime] date
);