CREATE TABLE documents (
    did TEXT
);

CREATE TABLE paragraphs (
    did        TEXT,
    pid        TEXT,
    paragraph  TEXT
);

CREATE TABLE entities (
	did     TEXT,
	pid     TEXT,
	eid     INTEGER,
	entity  TEXT,
	type    TEXT
);

CREATE TABLE tokens (
	did     TEXT,
	pid     TEXT,
	tid     INTEGER,
	token   TEXT,
	lemma   TEXT,
	pos     TEXT
);
