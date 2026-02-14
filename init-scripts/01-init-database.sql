-- ============================================================================
-- DATA1500 - Oppgavesett 1.5: Databasemodellering og implementasjon
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    user_role VARCHAR(20) NOT NULL,
    opprettet TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
CREATE TABLE IF NOT EXISTS virtualclassroom (
    classroom_id SERIAL PRIMARY KEY,
    code VARCHAR(30) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    teacher_id INT NOT NULL REFERENCES users(user_id),
    opprettet TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS groups (
    group_id SERIAL PRIMARY KEY,
    group_name VARCHAR(20) UNIQUE NOT NULL,
    opprettet TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS announcements (
    announcement_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL REFERENCES users(user_id),
    classroom_id INT NOT NULL REFERENCES virtualclassroom(classroom_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL
    );

CREATE TABLE IF NOT EXISTS forumposts (
    post_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL REFERENCES users(user_id),
    classroom_id INT NOT NULL REFERENCES virtualclassroom(classroom_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    parent_post_id INT REFERENCES forumposts(post_id)
    );

CREATE TABLE IF NOT EXISTS usergroup (
    user_id INT NOT NULL REFERENCES users(user_id),
    group_id INT NOT NULL REFERENCES groups(group_id),
    PRIMARY KEY (user_id, group_id)
    );

CREATE TABLE IF NOT EXISTS groupclassroomaccess (
    group_id INT NOT NULL REFERENCES groups(group_id),
    classroom_id INT NOT NULL REFERENCES virtualclassroom(classroom_id),
    PRIMARY KEY (group_id, classroom_id)
    );

-- Sett inn testdata

INSERT INTO users (username, password, user_role) VALUES
    ('tom_freddie', 'pass123', 'student'),
    ('nancy_petruini', 'pass456', 'student'),
    ('berg_bergerson', 'teachme', 'teacher');

INSERT INTO virtualclassroom (code, name, teacher_id) VALUES
    ('DATA1500', 'Databases and Data Modeling', 3);

INSERT INTO groups (group_name) VALUES
    ('Group A'),
    ('Group B');

INSERT INTO usergroup (user_id, group_id) VALUES
    (1, 1),
    (2, 1);

INSERT INTO groupclassroomaccess (group_id, classroom_id) VALUES
    (1, 1);

INSERT INTO announcements (sender_id, classroom_id, title, content) VALUES
    (3, 1, 'Welcome to DATA1500',
     'Welcome everyone! All course information will be posted here.');

INSERT INTO forumposts (sender_id, classroom_id, title, content) VALUES
    (1, 1, 'Question about assignments',
     'Will the assignments be individual or group based?');

INSERT INTO forumposts (sender_id, classroom_id, title, content, parent_post_id) VALUES
    (3, 1, 'Re: Question about assignments',
     'Assignments will be individual.', 1);

-- Eventuelt: Opprett indekser for ytelse
-- (valgfritt, kan stå tomt)

-- Vis at initialisering er fullført
SELECT 'Database initialisert!' as status;
