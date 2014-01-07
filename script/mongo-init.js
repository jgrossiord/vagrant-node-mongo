use test-application;
db.usercollection.ensureIndex( { "username": 1 }, { unique: true } );
newstuff = [
	{ "username" : "testuser1", "email" : "testuser1@testdomain.com" },
	{ "username" : "testuser2", "email" : "testuser2@testdomain.com" },
	{ "username" : "testuser3", "email" : "testuser3@testdomain.com" }
	];
db.usercollection.insert(newstuff);
