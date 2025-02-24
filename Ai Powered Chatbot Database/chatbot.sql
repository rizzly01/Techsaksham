create database chatbot;
use chatbot;
-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Conversations Table
CREATE TABLE Conversations (
    conversation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    status ENUM('active', 'completed', 'closed') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Messages Table
CREATE TABLE Messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT NOT NULL,
    sender ENUM('user', 'chatbot') NOT NULL,
    message_text TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES Conversations(conversation_id)
);

-- Query Patterns Table
CREATE TABLE QueryPatterns (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    query_text TEXT NOT NULL,
    frequency INT DEFAULT 1,
    last_asked TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chatbot Responses Table
CREATE TABLE ChatbotResponses (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    query_id INT NOT NULL,
    response_text TEXT NOT NULL,
    accuracy_score FLOAT DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (query_id) REFERENCES QueryPatterns(query_id)
);

-- AI Model Integration Table
CREATE TABLE AIModelIntegration (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(255) NOT NULL,
    version VARCHAR(50) NOT NULL,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);

INSERT INTO Users (user_name, email, phone_number) VALUES
('Kirti ', 'kirti@example.com', '1234567890'),
('Rutuja', 'rutuja@example.com', '0987654321'),
('vaishnvi', 'vaishnvi@example.com', '1122334455');
INSERT INTO Conversations (user_id, start_time, status) VALUES
(1, '2025-02-15 10:00:00', 'completed'),
(2, '2025-02-18 12:00:00', 'active'),
(3, '2025-02-19 14:00:00', 'completed');

INSERT INTO Messages (conversation_id, sender, message_text, timestamp) VALUES
(1, 'user', 'What is the weather today?', '2025-02-15 10:01:00'),
(1, 'chatbot', 'The weather is sunny with a high of 22°C.', '2025-02-15 10:01:30'),
(1, 'user', 'Can you tell me the news?', '2025-02-15 10:02:00'),
(1, 'chatbot', 'Here are the top headlines...', '2025-02-15 10:02:30'),
(2, 'user', 'What is the capital of France?', '2025-02-18 12:05:00'),
(2, 'chatbot', 'The capital of France is Paris.', '2025-02-18 12:05:30'),
(2, 'user', 'Tell me about the Eiffel Tower.', '2025-02-18 12:06:00'),
(2, 'chatbot', 'The Eiffel Tower is an iron lattice tower...', '2025-02-18 12:06:30'),
(3, 'user', 'What is the time in New York?', '2025-02-19 14:10:00'),
(3, 'chatbot', 'The time in New York is 10:10 AM.', '2025-02-19 14:10:30');

INSERT INTO QueryPatterns (query_text, frequency, last_asked) VALUES
('What is the weather today?', 5, '2025-02-15 10:01:00'),
('Can you tell me the news?', 3, '2025-02-15 10:02:00'),
('What is the capital of France?', 7, '2025-02-18 12:05:00'),
('Tell me about the Eiffel Tower.', 4, '2025-02-18 12:06:00'),
('What is the time in New York?', 2, '2025-02-19 14:10:00');

INSERT INTO ChatbotResponses (query_id, response_text, accuracy_score, created_at) VALUES
(1, 'The weather is sunny with a high of 22°C.', 0.95, '2025-02-15 10:01:30'),
(2, 'Here are the top headlines...', 0.90, '2025-02-15 10:02:30'),
(3, 'The capital of France is Paris.', 0.98, '2025-02-18 12:05:30'),
(4, 'The Eiffel Tower is an iron lattice tower...', 0.92, '2025-02-18 12:06:30'),
(5, 'The time in New York is 10:10 AM.', 0.97, '2025-02-19 14:10:30');
INSERT INTO AIModelIntegration (model_name, version, update_date, description) VALUES
('GPT-3', 'v1.0', '2025-02-01 00:00:00', 'Initial version of the GPT-3 model'),
('GPT-4', 'v1.0', '2025-02-19 00:00:00', 'Upgraded GPT-4 model for more accurate responses');

SELECT * FROM Users;

SELECT c.conversation_id, u.user_name, c.start_time 
FROM Conversations c 
JOIN Users u ON c.user_id = u.user_id;
SELECT query_text, frequency
FROM QueryPatterns
ORDER BY frequency DESC;

CREATE TABLE QueryPatterns1 (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    query_text TEXT NOT NULL,
    category VARCHAR(255),   -- New column for category
    frequency INT DEFAULT 1,
    last_asked TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO QueryPatterns1 (query_text, category, frequency, last_asked) VALUES
('What is the weather today?', 'Weather', 5, '2025-02-15 10:01:00'),
('Can you tell me the news?', 'General Inquiry', 3, '2025-02-15 10:02:00'),
('What is the capital of France?', 'Geography', 7, '2025-02-18 12:05:00'),
('Tell me about the Eiffel Tower.', 'Landmarks', 4, '2025-02-18 12:06:00'),
('What is the time in New York?', 'Time', 2, '2025-02-19 14:10:00');

SELECT query_text, category, frequency
FROM QueryPatterns1
ORDER BY frequency DESC;



