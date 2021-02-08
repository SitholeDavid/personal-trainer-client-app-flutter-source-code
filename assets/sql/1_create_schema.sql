CREATE TABLE bookings(
    startTime TEXT,
    sessionID TEXT,
    clientID TEXT
);

CREATE TABLE notifications(
    sessionID TEXT,
    notificationID INTEGER PRIMARY KEY
);

