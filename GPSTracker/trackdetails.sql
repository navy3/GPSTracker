CREATE TABLE IF NOT EXISTS "trackdetails"
(
	[did] integer PRIMARY KEY AUTOINCREMENT NOT NULL,
    [tid] integer,
	[contentType] integer,
	[content] text,
	[addTime] date
);