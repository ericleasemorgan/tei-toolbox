CREATE TABLE documents (
    did TEXT
);

CREATE TABLE sentences (
    did       TEXT,
    sid       TEXT,
    sentence  TEXT
);

CREATE TABLE entities (
	did     TEXT,
	sid     TEXT,
	eid     INTEGER,
	entity  TEXT,
	type    TEXT
);

CREATE TABLE tokens (
	did     TEXT,
	sid     TEXT,
	tid     INTEGER,
	token   TEXT,
	lemma   TEXT,
	pos     TEXT
);
