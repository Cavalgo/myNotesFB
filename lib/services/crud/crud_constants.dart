//Database file
const dbName = 'notes.db';
//Database tables
const noteTable = 'note';
const userTable = 'user';
//Database columns
const idColumn = 'id';
const emailColumn = 'email';
const userIDColumn = 'user_id';
const textColumn = 'text';
const isSyncWithCloudColumn = 'is_sync_with_cloud';
const lastModifiedDateColumn = 'last_modified_date';
//Table Creation queries
const String createUserTableCommand = '''CREATE TABLE IF NOT EXISTS "user"(
"id"	INTEGER NOT NULL,
"email"	TEXT NOT NULL UNIQUE,
PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const String createNoteTableCommand = '''CREATE TABLE "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_sync_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	"last_modified_date"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
