CREATE TABLE documents (
    did TEXT
);

CREATE TABLE sentences (
    did       TEXT,
    sid       INTEGER,
    sentence  TEXT
);

CREATE TABLE entities (
	did     TEXT,
	sid     INTEGER,
	eid     INTEGER,
	entity  TEXT,
	type    TEXT
);

CREATE TABLE tokens (
	did     TEXT,
	sid     INTEGER,
	tid     INTEGER,
	token   TEXT,
	lemma   TEXT,
	pos     TEXT
);
